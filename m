Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522144B9DC2
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 11:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbiBQK4Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 05:56:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiBQK4A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 05:56:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3428429413B
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 02:55:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E025CE2B10
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 10:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F9AC340ED;
        Thu, 17 Feb 2022 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645095342;
        bh=ZrsJw2kQHW4CITDMQm3E85apxW1QoqNCKZiZFdvS3zo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HBJgLcOqejCMZbyZzcIFbEDNRD90t/osvLSoIJiCIbrzlmTAiIzIdEQ2f8T4KmZhu
         FxPCg4gtMLkdpDdo6MEfIYhmKNJpRxdyfZfU2wd6uZ2weNJ3fjefSecNcfzxIBEdgB
         v5EQmGkzceh2ATEaBklk0RGmJPjoc/4ooXvMfkB9ptF5zFEEiZuB9FDXED0hl5vMpk
         CZdcXxk6jT5t3lARb+8WzUb7UyKlgTkbEijyd6a7at2Uu8orlfsq8q9R4O7wEp8mbR
         d09lxb0MopKvKgX6COjZ0cXQwy6t3pFs6WKVYbWxqv1Aqtklq0d70b6uLP/jVTOsO7
         K7sSk2Tjdmd5w==
Message-ID: <896b780d82a37a04e0533b69049c0112d4327055.camel@kernel.org>
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is
 no new snapshot
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Thu, 17 Feb 2022 05:55:41 -0500
In-Reply-To: <CAAM7YAn8QtZZORXbczE4cLdvGrrEW=AeaAM22f9EK4YNopo+qg@mail.gmail.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
         <20220215122316.7625-4-xiubli@redhat.com>
         <CAAM7YAn8QtZZORXbczE4cLdvGrrEW=AeaAM22f9EK4YNopo+qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-02-17 at 11:03 +0800, Yan, Zheng wrote:
> On Tue, Feb 15, 2022 at 11:04 PM <xiubli@redhat.com> wrote:
> > 
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > No need to update snapshot context when any of the following two
> > cases happens:
> > 1: if my context seq matches realm's seq and realm has no parent.
> > 2: if my context seq equals or is larger than my parent's, this
> >    works because we rebuild_snap_realms() works _downward_ in
> >    hierarchy after each update.
> > 
> > This fix will avoid those inodes which accidently calling
> > ceph_queue_cap_snap() and make no sense, for exmaple:
> > 
> > There have 6 directories like:
> > 
> > /dir_X1/dir_X2/dir_X3/
> > /dir_Y1/dir_Y2/dir_Y3/
> > 
> > Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
> > make a root snapshot under /.snap/root_snap. And every time when
> > we make snapshots under /dir_Y1/..., the kclient will always try
> > to rebuild the snap context for snap_X2 realm and finally will
> > always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
> > no sense.
> > 
> > That's because the snap_X2's seq is 2 and root_snap's seq is 3.
> > So when creating a new snapshot under /dir_Y1/... the new seq
> > will be 4, and then the mds will send kclient a snapshot backtrace
> > in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
> > it will always rebuild the from the last realm, that's the root_snap.
> > So later when rebuilding the snap context it will always rebuild
> > the snap_X2 realm and then try to queue cap snaps for all the inodes
> > related in snap_X2 realm, and we are seeing the logs like:
> > 
> > "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
> > 
> > URL: https://tracker.ceph.com/issues/44100
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/snap.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index d075d3ce5f6d..1f24a5de81e7 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
> >                 num += parent->cached_context->num_snaps;
> >         }
> > 
> > -       /* do i actually need to update?  not if my context seq
> > -          matches realm seq, and my parents' does to.  (this works
> > -          because we rebuild_snap_realms() works _downward_ in
> > -          hierarchy after each update.) */
> > +       /* do i actually need to update? No need when any of the following
> > +        * two cases:
> > +        * #1: if my context seq matches realm's seq and realm has no parent.
> > +        * #2: if my context seq equals or is larger than my parent's, this
> > +        *     works because we rebuild_snap_realms() works _downward_ in
> > +        *     hierarchy after each update.
> > +        */
> >         if (realm->cached_context &&
> > -           realm->cached_context->seq == realm->seq &&
> > -           (!parent ||
> > -            realm->cached_context->seq >= parent->cached_context->seq)) {
> > +           ((realm->cached_context->seq == realm->seq && !parent) ||
> > +            (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
> 
> With this change. When you mksnap on  /dir_Y1/, its snap context keeps
> unchanged. In ceph_update_snap_trace, reset the 'invalidate' variable
> for each realm should fix this issue.
> 

This comment is terribly vague. "invalidate" is a local variable in that
function and isn't set on a per-realm basis.

Could you suggest a patch on top of Xiubo's patch instead?


> >                 dout("build_snap_context %llx %p: %p seq %lld (%u snaps),
> >                      " (unchanged)\n",
> >                      realm->ino, realm, realm->cached_context,
> > --
> > 2.27.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>
