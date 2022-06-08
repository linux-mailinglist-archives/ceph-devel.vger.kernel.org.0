Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE76543206
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiFHN6P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 09:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241069AbiFHN6P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 09:58:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78C72AA9B9
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 06:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86BDBB827DF
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 13:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1CFC34116;
        Wed,  8 Jun 2022 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654696689;
        bh=YEvRoWZWq5JoQIRei9an0RMJ3xCwOT0jmUD7/5MTdL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PbF5TYf+kEuXgRNc8PSL9jP3RUdiOtcaOmXG6nTVovzdJlbVFbJqTXdzdrL/cI5rs
         kWsIXMFxvJ+5kb+81qt+egPG4sRzBGTK/yDxtEaxBsN1JLQetKh1+IXzETW9DhILPi
         imrksFsehIJy9cQYuP/fHtYfdiYTpWpFaFWaFEm9CGPqS04grqThE3UbjcPVYMCUFC
         6FKE5t4+Rt1ICxPMsDaPL0V177Xmcr9D9JUAYlTn/5X/wa9wfDMfwo+OZOECqlmM+T
         TrDiWl60MhLN1ejTdj9FTKDfycU4a8gv6iU1H4Airp7NRCSjXkI8D4PU9WrIPy6EC3
         MANd53wvsHuEQ==
Message-ID: <ed45a5ddc10dd805506419306d1eb7a8120fe2ad.camel@kernel.org>
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Date:   Wed, 08 Jun 2022 09:58:07 -0400
In-Reply-To: <d51679b8-d523-ce95-d8fc-9a6d3cc78cc6@redhat.com>
References: <20220606233142.150457-1-jlayton@kernel.org>
         <e0dac29b-f6e6-84bd-c548-06106e345554@redhat.com>
         <82bb2d6f8c890405a276e3ceffaa6550681f3b38.camel@kernel.org>
         <d51679b8-d523-ce95-d8fc-9a6d3cc78cc6@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-06-07 at 09:50 +0800, Xiubo Li wrote:
> On 6/7/22 9:21 AM, Jeff Layton wrote:
> > On Tue, 2022-06-07 at 09:11 +0800, Xiubo Li wrote:
> > > On 6/7/22 7:31 AM, Jeff Layton wrote:
> > > > Currently, we'll call ceph_check_caps, but if we're still waiting o=
n the
> > > > reply, we'll end up spinning around on the same inode in
> > > > flush_dirty_session_caps. Wait for the async create reply before
> > > > flushing caps.
> > > >=20
> > > > Fixes: fbed7045f552 (ceph: wait for async create reply before sendi=
ng any cap messages)
> > > > URL: https://tracker.ceph.com/issues/55823
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >    fs/ceph/caps.c | 1 +
> > > >    1 file changed, 1 insertion(+)
> > > >=20
> > > > I don't know if this will fix the tx queue stalls completely, but I
> > > > haven't seen one with this patch in place. I think it makes sense o=
n its
> > > > own, either way.
> > > >=20
> > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > index 0a48bf829671..5ecfff4b37c9 100644
> > > > --- a/fs/ceph/caps.c
> > > > +++ b/fs/ceph/caps.c
> > > > @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct c=
eph_mds_session *s)
> > > >    		ihold(inode);
> > > >    		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> > > >    		spin_unlock(&mdsc->cap_dirty_lock);
> > > > +		ceph_wait_on_async_create(inode);
> > > >    		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> > > >    		iput(inode);
> > > >    		spin_lock(&mdsc->cap_dirty_lock);
> > > This looks good.
> > >=20
> > > Possibly we can add one dedicated list to store the async creating
> > > inodes instead of getting stuck all the others ?
> > >=20
> > I'd be open to that. I think we ought to take this patch first to fix
> > the immediate bug though, before we add extra complexity.
>=20
> Sounds good to me.
>=20
> I will merge it to the testing branch for now and let's improve it later.
>=20

Can we also mark this for stable? It's a pretty nasty bug, potentially.
We should get this into mainline fairly soon.

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>
