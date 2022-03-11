Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6DC4D6462
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 16:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbiCKPR0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 10:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiCKPR0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 10:17:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472AC1C57C8
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 07:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7059B82C08
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 15:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC72C340ED;
        Fri, 11 Mar 2022 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647011779;
        bh=FiiVn8pATNVj5V2nVJqD+XQ7KGEVNEsWSPqrSiF4Pk4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GsknqK4aABrldlqKcvzXwZqaU3QZEfQa06F5efGk38k3f6bftuQNNSPh8dAjfcI5p
         XuMDIarB/2Rqect8eQhkOa4Dco1HFz/Fcpt1FMIs0EYwx/suxq9E1nvnMAkUN2MWI7
         XGXgxAABILwI2yJV9H60GFyqUdA2AzNtCV0TFQ5y4Tn0Xf87fn7Pl8DPiDqfoFxxeh
         hZBmZxdMgzmYQfXm1ol9LToemp4JQ0NeFO566ECOih0eGIoNBWlQgiJs94PohZslpb
         NCts06Uas/r2SpXjGYU4idD7VfXkI19VG/Ur0UADdWTf6GQhDSMQ//CEFTz15uQjqA
         e3GaVQoaNgonQ==
Message-ID: <12877268cdbd9fabfec0ee40e8684467984e15f5.camel@kernel.org>
Subject: Re: [PATCH] ceph: allow `ceph.dir.rctime' xattr to be updatable
From:   Jeff Layton <jlayton@kernel.org>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 11 Mar 2022 10:16:17 -0500
In-Reply-To: <20220310143419.14284-1-vshankar@redhat.com>
References: <20220310143419.14284-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-10 at 09:34 -0500, Venky Shankar wrote:
> `rctime' has been a pain point in cephfs due to its buggy
> nature - inconsistent values reported and those sorts.
> Fixing rctime is non-trivial needing an overall redesign
> of the entire nested statistics infrastructure.
> 
> As a workaround, PR
> 
>      http://github.com/ceph/ceph/pull/37938
> 
> allows this extended attribute to be manually set. This allows
> users to "fixup" inconsistency rctime values. While this sounds
> messy, its probably the wisest approach allowing users/scripts
> to workaround buggy rctime values.
> 
> The above PR enables Ceph MDS to allow manually setting
> rctime extended attribute with the corresponding user-land
> changes. We may as well allow the same to be done via kclient
> for parity.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/xattr.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index afec84088471..8c2dc2c762a4 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -366,6 +366,14 @@ static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
>  	}
>  #define XATTR_RSTAT_FIELD(_type, _name)			\
>  	XATTR_NAME_CEPH(_type, _name, VXATTR_FLAG_RSTAT)
> +#define XATTR_RSTAT_FIELD_UPDATABLE(_type, _name)			\
> +	{								\
> +		.name = CEPH_XATTR_NAME(_type, _name),			\
> +		.name_size = sizeof (CEPH_XATTR_NAME(_type, _name)),	\
> +		.getxattr_cb = ceph_vxattrcb_ ## _type ## _ ## _name,	\
> +		.exists_cb = NULL,					\
> +		.flags = VXATTR_FLAG_RSTAT,				\
> +	}
>  #define XATTR_LAYOUT_FIELD(_type, _name, _field)			\
>  	{								\
>  		.name = CEPH_XATTR_NAME2(_type, _name, _field),	\
> @@ -404,7 +412,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>  	XATTR_RSTAT_FIELD(dir, rsubdirs),
>  	XATTR_RSTAT_FIELD(dir, rsnaps),
>  	XATTR_RSTAT_FIELD(dir, rbytes),
> -	XATTR_RSTAT_FIELD(dir, rctime),
> +	XATTR_RSTAT_FIELD_UPDATABLE(dir, rctime),
>  	{
>  		.name = "ceph.dir.pin",
>  		.name_size = sizeof("ceph.dir.pin"),

Thanks Venky, looks good. Merged into testing branch.
-- 
Jeff Layton <jlayton@kernel.org>
