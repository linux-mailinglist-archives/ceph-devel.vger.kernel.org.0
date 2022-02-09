Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45294AF0A1
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiBIMDb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 07:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiBIMDK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 07:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699BDC02B64D
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 03:34:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888CE615C7
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 11:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C40C340E9;
        Wed,  9 Feb 2022 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644406492;
        bh=8+X1CGFW4x5WybGRdFhwKh2qYWQH0qLyuMuOBhT+qM0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jaiRfaKBCH2LRG1Swd1bpnxt3/TePNa+tTxukx8MZ78wzmHjk6We+qiRU5lnjFekb
         2pksyq9CIuuMuVrVuT8/BdfEEAiwaxkZjWNBXgalbf97sYqVBNBWJ/z/2KMAW7Mrhu
         f1JmCbdBD4swwvtKcQvDKcZ236Z52E5dssPKGScih5DPLwkXi+Vz9T7uDceGJ5E+Ea
         90T8vt5FxovwdAvkDHusUowHmE2Kr2VCM0OSbZ2wlXjPDbpE77iAj/IjIuhsYHfJnW
         yPPXIWIMuJKFfrF/LKHlMZ2f81+MUnbAnTYKIhW5Y1u3OKTbAwAC8MwXe7LU5EshqP
         83SYRGVDUxejQ==
Message-ID: <1f423338f4ff9e70b5439b2dce9745710c876d1b.camel@kernel.org>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     Dan van der Ster <dan@vanderster.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Date:   Wed, 09 Feb 2022 06:34:49 -0500
In-Reply-To: <3e2d66b0-a0e9-be31-a803-f7a4ff687c78@redhat.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
         <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
         <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
         <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
         <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
         <9ee4afece5bc3445ed19a3344a11eeab697ff37e.camel@kernel.org>
         <3e2d66b0-a0e9-be31-a803-f7a4ff687c78@redhat.com>
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

On Wed, 2022-02-09 at 14:00 +0800, Xiubo Li wrote:
> On 2/8/22 1:11 AM, Jeff Layton wrote:
> > On Mon, 2022-02-07 at 08:28 -0800, Gregory Farnum wrote:
> > > On Mon, Feb 7, 2022 at 8:13 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > The tracker bug mentions that this occurs after an MDS is restarted.
> > > > Could this be the result of clients relying on delete-on-last-close
> > > > behavior?
> > > Oooh, I didn't actually look at the tracker.
> > > 
> > > > IOW, we have a situation where a file is opened and then unlinked, and
> > > > userland is actively doing I/O to it. The thing gets moved into the
> > > > strays dir, but isn't unlinked yet because we have open files against
> > > > it. Everything works fine at this point...
> > > > 
> > > > Then, the MDS restarts and the inode gets purged altogether. Client
> > > > reconnects and tries to reclaim his open, and gets ESTALE.
> > > Uh, okay. So I didn't do a proper audit before I sent my previous
> > > reply, but one of the cases I did see was that the MDS returns ESTALE
> > > if you try to do a name lookup on an inode in the stray directory. I
> > > don't know if that's what is happening here or not? But perhaps that's
> > > the root of the problem in this case.
> > > 
> > > Oh, nope, I see it's issuing getattr requests. That doesn't do ESTALE
> > > directly so it must indeed be coming out of MDCache::path_traverse.
> > > 
> > > The MDS shouldn't move an inode into the purge queue on restart unless
> > > there were no clients with caps on it (that state is persisted to disk
> > > so it knows). Maybe if the clients don't make the reconnect window
> > > it's dropping them all and *then* moves it into purge queue? I think
> > > we need to identify what's happening there before we issue kernel
> > > client changes, Xiubo?
> > 
> > Agreed. I think we need to understand why he's seeing ESTALE errors in
> > the first place, but it sounds like retrying on an ESTALE error isn't
> > likely to be helpful.
> 
> There has one case that could cause the inode to be put into the purge 
> queue:
> 
> 1, When unlinking a file and just after the unlink journal log is 
> flushed and the MDS is restart or replaced by a standby MDS. The unlink 
> journal log will contain the a straydn and the straydn will link to the 
> related CInode.
> 
> 2, The new starting MDS will replay this unlink journal log in 
> up:standby_replay state.
> 
> 3, The MDCache::upkeep_main() thread will try to trim MDCache, and it 
> will possibly trim the straydn. Since the clients haven't reconnected 
> the sessions, so the CInode won't have any client cap. So when trimming 
> the straydn and CInode, the CInode will be put into the purge queue.
> 
> 4, After up:reconnect, when retrying the getattr requests the MDS will 
> return ESTALE.
> 
> This should be fixed in https://github.com/ceph/ceph/pull/41667 
> recently, it will just enables trim() in up:active state.
> 
> I also went through the ESTALE related code in MDS, this patch still 
> makes sense and when getting an ESTALE errno to retry the request make 
> no sense.
> 

Agreed. I think retrying an operation directly on an ESTALE makes no
sense, and it probably prevents the ESTALE handling in the vfs layer
from working properly.

Usually, when we get back an ESTALE error on NFS with a path-based
operation, it means that it did a lookup (often out of the client's
cache) and found an inode, but by the time we got around to doing the
operation, the filehandle had vanished from the server. The kernel will
then go and set LOOKUP_REVAL and do the pathwalk again (since that's a
pretty good indicator that the dcache was wrong).

It's a bit different in ceph since it's a (semi-)path-based protocol,
and the lookup cache coherency is tighter, but I think the same sort of
races are probably possible. Allowing ESTALE to bubble back up to the
VFS layer would allow it to retry the lookups and do it again.

I'm going to plan to take this patch into testing branch and aim for it
to go into v5.18.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
