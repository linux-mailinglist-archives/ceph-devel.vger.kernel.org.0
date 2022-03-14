Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6164D82E2
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240821AbiCNMLj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Mar 2022 08:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242810AbiCNMK5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Mar 2022 08:10:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D2E2FFD8
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 05:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21AE6135D
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 12:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C36C340ED;
        Mon, 14 Mar 2022 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647259781;
        bh=FGW8MCPR7HElej5vwVfENjAEVc0ZOi+y4IRlN+LrleQ=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=GrmIXwWrUU6fy9v7wG3HyKO1P8c/sCipHbJPRXhyWOflUpuyimMqLYdyZa5NAgMyQ
         U/rgczUoka8InOzHOfzIp3KxRAicrHeE+bEqgklEDTTcGv4Y8pFyX4zZlk5j3lhzJ8
         wMCSVQjQwjFktXMv1NqBiXYtx8AqnIQjzDNUDvk5HybUOszZMhUYdoXnNZlnrJON82
         /A563nCJ6C6NoVz8m7cra7k3jeXqmDbsKgEKVE2H8LZk4YuDjd8WiDC0W67ygcbET0
         4BKAGjaGiE5HZ2mqXpcMBH7GiywWfAqxfe+NEKdZoKBFvwHcrU4uwQ7qciNAIcMtse
         5dwgbfoudQHaQ==
Message-ID: <d2cd0dd047c40686d2b5e3b64131112a95581a60.camel@kernel.org>
Subject: Re: [PATCH 3/3] ceph: convert to sparse reads
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Date:   Mon, 14 Mar 2022 08:09:39 -0400
In-Reply-To: <393b92d5-ce25-92dd-936f-049d7a819d13@redhat.com>
References: <20220309123323.20593-1-jlayton@kernel.org>
         <20220309123323.20593-4-jlayton@kernel.org>
         <393b92d5-ce25-92dd-936f-049d7a819d13@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-03-14 at 10:22 +0800, Xiubo Li wrote:
> On 3/9/22 8:33 PM, Jeff Layton wrote:
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/addr.c | 2 +-
> >   fs/ceph/file.c | 4 ++--
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 752c421c9922..f42440d7102b 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -317,7 +317,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
> >   		return;
> >   
> >   	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
> > -			0, 1, CEPH_OSD_OP_READ,
> > +			0, 1, CEPH_OSD_OP_SPARSE_READ,
> 
> For this possibly should we add one option to disable it ? Just in case 
> we need to debug the fscrypt or something else when we hit the 
> read/write related issue ?
> 
> 

Yeah, it's probably a reasonable thing to add. I had that at one point
in development and dropped it. Let me see if I can resurrect that before
I post a v2.

> 
> >   			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
> >   			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
> >   	if (IS_ERR(req)) {
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index feb75eb1cd82..d1956a20c627 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -934,7 +934,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> >   
> >   		req = ceph_osdc_new_request(osdc, &ci->i_layout,
> >   					ci->i_vino, off, &len, 0, 1,
> > -					CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
> > +					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
> >   					NULL, ci->i_truncate_seq,
> >   					ci->i_truncate_size, false);
> >   		if (IS_ERR(req)) {
> > @@ -1291,7 +1291,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
> >   					    vino, pos, &size, 0,
> >   					    1,
> >   					    write ? CEPH_OSD_OP_WRITE :
> > -						    CEPH_OSD_OP_READ,
> > +						    CEPH_OSD_OP_SPARSE_READ,
> >   					    flags, snapc,
> >   					    ci->i_truncate_seq,
> >   					    ci->i_truncate_size,
> 

-- 
Jeff Layton <jlayton@kernel.org>
