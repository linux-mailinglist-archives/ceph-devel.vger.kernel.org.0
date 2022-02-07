Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6214AC586
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356063AbiBGQ1O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 11:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiBGQNP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 11:13:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C7C0401CC
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C290B81625
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 16:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DE8C004E1;
        Mon,  7 Feb 2022 16:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644250392;
        bh=v9rxLKnkAGH5S4jqn6PBjD68WXGcf7Zhj3Smpd42p+4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i8Q7jB8F1ngHrT6nSNxLG2WjWzb0tfCG7KjfF6Eqbyd1DetmdDSgZRhjuvDgDLdXe
         qVA2rRaCe++x2PRBmzvDaEgl/Oe0/r/y2x/bfSTYMqe9ZIUu/aRCIBncTrE34S0/HP
         aWo4RCuFhdWnQ4Ckj0wVxboAARmld/5+FG0TObEHLoX1VRzPG1RXNzIjjew4fiPiKC
         jMoQ6e5yzKBn8v9Lcfw/opHhvQ2HnCCczjmjRyvqUhpcNJndMzMVX4903tRvS/AndQ
         EMr9XyQFu7OfkxRMj2sDSWV2+XAT2S0RBXI6dOe0KIUooC4E88qkNuRiQcOpafUJCO
         KAgfXbXxU/kew==
Message-ID: <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>,
        Dan van der Ster <dan@vanderster.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Date:   Mon, 07 Feb 2022 11:13:10 -0500
In-Reply-To: <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
         <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
         <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-02-07 at 07:40 -0800, Gregory Farnum wrote:
> On Mon, Feb 7, 2022 at 7:12 AM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > If MDS return ESTALE, that means the MDS has already iterated all
> > > the possible active MDSes including the auth MDS or the inode is
> > > under purging. No need to retry in auth MDS and will just return
> > > ESTALE directly.
> > > 
> > 
> > When you say "purging" here, do you mean that it's effectively being
> > cleaned up after being unlinked? Or is it just being purged from the
> > MDS's cache?
> > 
> > > Or it will cause definite loop for retrying it.
> > > 
> > > URL: https://tracker.ceph.com/issues/53504
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >  fs/ceph/mds_client.c | 29 -----------------------------
> > >  1 file changed, 29 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 93e5e3c4ba64..c918d2ac8272 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> > > 
> > >       result = le32_to_cpu(head->result);
> > > 
> > > -     /*
> > > -      * Handle an ESTALE
> > > -      * if we're not talking to the authority, send to them
> > > -      * if the authority has changed while we weren't looking,
> > > -      * send to new authority
> > > -      * Otherwise we just have to return an ESTALE
> > > -      */
> > > -     if (result == -ESTALE) {
> > > -             dout("got ESTALE on request %llu\n", req->r_tid);
> > > -             req->r_resend_mds = -1;
> > > -             if (req->r_direct_mode != USE_AUTH_MDS) {
> > > -                     dout("not using auth, setting for that now\n");
> > > -                     req->r_direct_mode = USE_AUTH_MDS;
> > > -                     __do_request(mdsc, req);
> > > -                     mutex_unlock(&mdsc->mutex);
> > > -                     goto out;
> > > -             } else  {
> > > -                     int mds = __choose_mds(mdsc, req, NULL);
> > > -                     if (mds >= 0 && mds != req->r_session->s_mds) {
> > > -                             dout("but auth changed, so resending\n");
> > > -                             __do_request(mdsc, req);
> > > -                             mutex_unlock(&mdsc->mutex);
> > > -                             goto out;
> > > -                     }
> > > -             }
> > > -             dout("have to return ESTALE on request %llu\n", req->r_tid);
> > > -     }
> > > -
> > > -
> > >       if (head->safe) {
> > >               set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
> > >               __unregister_request(mdsc, req);
> > 
> > 
> > (cc'ing Greg, Sage and Zheng)
> > 
> > This patch sort of contradicts the original design, AFAICT, and I'm not
> > sure what the correct behavior should be. I could use some
> > clarification.
> > 
> > The original code (from the 2009 merge) would tolerate 2 ESTALEs before
> > giving up and returning that to userland. Then in 2010, Greg added this
> > commit:
> > 
> >     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f
> > 
> > ...which would presumably make it retry indefinitely as long as the auth
> > MDS kept changing. Then, Zheng made this change in 2013:
> > 
> >     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938
> > 
> > ...which seems to try to do the same thing, but detected the auth mds
> > change in a different way.
> > 
> > Is that where livelock detection was broken? Or was there some
> > corresponding change to __choose_mds that should prevent infinitely
> > looping on the same request?
> > 
> > In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
> > and that the server has forgotten about it. Does it mean the same thing
> > to the ceph MDS?
> 
> This used to get returned if the MDS couldn't find the inode number in
> question, because . This was not possible in most cases because if the
> client has caps on the inode, it's pinned in MDS cache, but was
> possible when NFS was layered on top (and possibly some other edge
> case APIs where clients can operate on inode numbers they've saved
> from a previous lookup?).
> 

The tracker bug mentions that this occurs after an MDS is restarted.
Could this be the result of clients relying on delete-on-last-close
behavior?

IOW, we have a situation where a file is opened and then unlinked, and
userland is actively doing I/O to it. The thing gets moved into the
strays dir, but isn't unlinked yet because we have open files against
it. Everything works fine at this point...

Then, the MDS restarts and the inode gets purged altogether. Client
reconnects and tries to reclaim his open, and gets ESTALE.

NFS clients prevent this by doing something called a silly-rename,
though client crashes can leave silly-renamed files sitting around (you
may have seen the .nfsXXXXXXXXXXXXXX files in some NFS-exported
filesystems).

> > 
> > Has the behavior of the MDS changed such that these retries are no
> > longer necessary on an ESTALE? If so, when did this change, and does the
> > client need to do anything to detect what behavior it should be using?
> 
> Well, I see that CEPHFS_ESTALE is still returned sometimes from the
> MDS, so somebody will need to audit those, but the MDS has definitely
> changed. These days, we can look up an unknown inode using the
> (directory) backtrace we store on its first RADOS object, and it does
> (at least some of the time? But I think everywhere relevant). But that
> happened when we first added scrub circa 2014ish? Previously if the
> inode wasn't in cache, we just had no way of finding it.


Ok, could you send an Acked-by if you think Xiubo's logic is correct?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
