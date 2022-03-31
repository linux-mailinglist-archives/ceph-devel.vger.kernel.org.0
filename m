Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB994ED755
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 11:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiCaJy5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 05:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCaJy4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 05:54:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E012016BC
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C00DB82067
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 09:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618C3C340EE;
        Thu, 31 Mar 2022 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648720386;
        bh=XRv4NqGxntCPcV6swY5gn4tHhkrjkt5YjN1iOcC6718=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cmQahJQwMPeJhzBmJ2yd/LcSa+XUcgzeOFvkLa4vYv2zNBrzWr6XV4+MdLOiJxsqr
         +XABvFvKZ2bm4uHiQFEVooXYJ7B+3wVNOlRmAO2hkVRIMsTroWkhfVumghqPncWCB6
         O2v5mDy/KSIi+PPSfKx/UIQIIC+oCn6/kgh9YRMP5t7003r0yv8cbH9g8kNtpqXAaU
         w36TaXvJqD9JgpQFn275cZxplra9xdwFi3y468B88l2ZynIuYd7c3388aoRZ5Eosk6
         DVKjbtJojP3bhBYOothm/iXDM/kdo3Juqj8QvquI6hadgYqErcjcuB6MF7WgVfAccI
         X08JM6SJTCmMQ==
Message-ID: <ffc91437b148637bf08f1c8c3bf9bdbcb39e3b0d.camel@kernel.org>
Subject: Re: [PATCH] ceph: discard r_new_inode if open O_CREAT opened
 existing inode
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com,
        =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 31 Mar 2022 05:53:05 -0400
In-Reply-To: <fa050107-0103-54d9-5e3c-2f29629d231d@redhat.com>
References: <20220330190457.73279-1-jlayton@kernel.org>
         <fa050107-0103-54d9-5e3c-2f29629d231d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-31 at 09:47 +0800, Xiubo Li wrote:
> On 3/31/22 3:04 AM, Jeff Layton wrote:
> > When we do an unchecked create, we optimistically pre-create an inode
> > and populate it, including its fscrypt context. It's possible though
> > that we'll end up opening an existing inode, in which case the
> > precreated inode will have a crypto context that doesn't match the
> > existing data.
> > 
> > If we're issuing an O_CREAT open and find an existing inode, just
> > discard the precreated inode and create a new one to ensure the context
> > is properly set.
> > 
> > Cc: Luís Henriques <lhenriques@suse.de>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/mds_client.c | 10 ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 840a60b812fc..b03128fdbb07 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> >   	/* Must find target inode outside of mutexes to avoid deadlocks */
> >   	rinfo = &req->r_reply_info;
> >   	if ((err >= 0) && rinfo->head->is_target) {
> > -		struct inode *in;
> > +		struct inode *in = xchg(&req->r_new_inode, NULL);
> >   		struct ceph_vino tvino = {
> >   			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
> >   			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
> >   		};
> >   
> > -		in = ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, NULL));
> > +		/* If we ended up opening an existing inode, discard r_new_inode */
> > +		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
> > +			iput(in);
> 
> If the 'in' has a delegated ino, should we give it back here ?
> 
> -- Xiubo
> 
> 

This really shouldn't be a delegated ino. We only grab a delegated ino
if we're doing an async create, and in that case we should know that the
dentry doesn't exist and the create will succeed or fail without opening
the file.

It's probably worth throwing a warning though if we ever _do_ get a
delegated ino here. Let me consider how best to catch that situation.

> > +			in = NULL;
> > +		}
> > +
> > +		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
> >   		if (IS_ERR(in)) {
> >   			err = PTR_ERR(in);
> >   			mutex_lock(&session->s_mutex);
> 

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
