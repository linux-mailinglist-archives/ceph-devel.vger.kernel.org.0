Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C9B518499
	for <lists+ceph-devel@lfdr.de>; Tue,  3 May 2022 14:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiECMwn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 May 2022 08:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiECMwm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 May 2022 08:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90413464B
        for <ceph-devel@vger.kernel.org>; Tue,  3 May 2022 05:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DA5C616D5
        for <ceph-devel@vger.kernel.org>; Tue,  3 May 2022 12:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D040C385A9;
        Tue,  3 May 2022 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651582149;
        bh=jJRlCLX8ou18HxFaT9fUN4bEuoB0wzRM4xzF0NUzV3I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O/7BgnKIaY5QqnYGNaE8AK+d+Fs2mHmQP43fjTw0AfMjOLhAMy7IqdREydG/iwE7D
         zSoJyCjdLosaUXxLIszT1lxvfywgH2qZ5U17VjwE2ncx1vlPjmdob3fh9wYmUToAfX
         7RNOsgNLbSOIr+Gj2br3lL7D1dRNIRpu2ox+p0Fc/2SAVgDXleNrZvyaenwyBmmJtD
         QeyJ+UKNnFFrbselklmE82pzMt6TMMq6mlR3x8yj132ZJ5klO18MqOFn5fth1lzRkx
         p1caidbeoP0/LQW6ML9f0K4Qx03ng8Zaz5ex3CW6d81IzpNn/pjB5Plf9tNphStq9A
         d3OnmJUcI9JUg==
Message-ID: <618528f07d5a6d397a76d954c43a5ff59422d83e.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked
 and not used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 03 May 2022 08:49:07 -0400
In-Reply-To: <8dff2592-03cb-0ef1-e538-ae4b0484c567@redhat.com>
References: <20220428121318.43125-1-xiubli@redhat.com>
         <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
         <8dff2592-03cb-0ef1-e538-ae4b0484c567@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-04-29 at 14:28 +0800, Xiubo Li wrote:
> On 4/29/22 10:46 AM, Yan, Zheng wrote:
> > On Thu, Apr 28, 2022 at 11:42 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > For example if the Frwcb caps are being revoked, but only the Fr
> > > caps is still being used then the kclient will skip releasing them
> > > all. But in next turn if the Fr caps is ready to be released the
> > > Fw caps maybe just being used again. So in corner case, such as
> > > heavy load IOs, the revocation maybe stuck for a long time.
> > > 
> > This does not make sense. If Frwcb are being revoked, writer can't get
> > Fw again. Second, Frwcb are managed by single lock at mds side.
> > Partial releasing caps does make lock state transition possible.
> > 
> Yeah, you are right. Checked the __ceph_caps_issued() it really has 
> removed the caps being revoked already.
> 
> Thanks Zheng.
> 

Based on this discussion, I'm going to drop this patch from the testing
branch.

> 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/caps.c | 7 +++++++
> > >   1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 0c0c8f5ae3b3..7eb5238941fc 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> > > 
> > >          /* The ones we currently want to retain (may be adjusted below) */
> > >          retain = file_wanted | used | CEPH_CAP_PIN;
> > > +
> > > +       /*
> > > +        * Do not retain the capabilities if they are under revoking
> > > +        * but not used, this could help speed up the revoking.
> > > +        */
> > > +       retain &= ~((revoking & retain) & ~used);
> > > +
> > >          if (!mdsc->stopping && inode->i_nlink > 0) {
> > >                  if (file_wanted) {
> > >                          retain |= CEPH_CAP_ANY;       /* be greedy */
> > > --
> > > 2.36.0.rc1
> > > 
> 

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
