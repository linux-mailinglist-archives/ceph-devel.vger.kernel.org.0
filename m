Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC153B7595
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhF2Pkh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234549AbhF2Pkg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EAA261DA6;
        Tue, 29 Jun 2021 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624981089;
        bh=kxEuqfvom1KSbHevk8q5gIk8c52qyw6ZC2smvpjFfLI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N6GUY7aKhAzJPB/7bDrPgxlzTSaR2lZ6TRwMdoNaKDVHxMp6sz8XEMmer9OTZtnI3
         /GKCRqLUDEWOjj6AYzGcAMi9JtfUA3GTYaeN5SCZtm1QojnzGa/clMaeRi5DFYPjx4
         tXQqv0ivzHmAUiRzSx1QYmU/BM2oiggvRJNDAk298ZEiCv6/gQpAQ63ynmRQZfou8K
         BziQtFhNtI6MC56irrK/n4brVw1L1DgSLc5R4YsSwhJFg03rtEtpX8ZHDhq/PiNN0K
         KvUa7e6Iks94rBM4CXNk4inOPLl3ONAjnEpB3QI72oT8Yaz0tLGsZtj+pMlVOqG8XB
         QbNULmkbWK5CA==
Message-ID: <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
Subject: Re: [PATCH 5/5] ceph: fix ceph feature bits
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 11:38:08 -0400
In-Reply-To: <20210629044241.30359-6-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-6-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 79d5b8ed62bf..b18eded84ede 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -27,7 +27,9 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_RECLAIM_CLIENT,
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>  	CEPHFS_FEATURE_MULTI_RECONNECT,
> +	CEPHFS_FEATURE_NAUTILUS,
>  	CEPHFS_FEATURE_DELEG_INO,
> +	CEPHFS_FEATURE_OCTOPUS,
>  	CEPHFS_FEATURE_METRIC_COLLECT,
>  
>  	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> @@ -43,7 +45,9 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_REPLY_ENCODING,		\
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> +	CEPHFS_FEATURE_NAUTILUS,		\
>  	CEPHFS_FEATURE_DELEG_INO,		\
> +	CEPHFS_FEATURE_OCTOPUS,			\
>  	CEPHFS_FEATURE_METRIC_COLLECT,		\
>  						\
>  	CEPHFS_FEATURE_MAX,			\

Do we need this? I thought we had decided to deprecate the whole concept
of release-based feature flags.

-- 
Jeff Layton <jlayton@kernel.org>

