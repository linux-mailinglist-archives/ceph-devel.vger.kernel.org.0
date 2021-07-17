Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20DD3CC2C9
	for <lists+ceph-devel@lfdr.de>; Sat, 17 Jul 2021 13:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhGQLYj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 17 Jul 2021 07:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhGQLYi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 07:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF70613C3;
        Sat, 17 Jul 2021 11:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626520902;
        bh=jch7FlNC1SqbGddFtiq2NgBC++QLR547DuIsvNiUI3w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kvR4FUdlcavrtC6xfnJUJL7Eco/yUkzjfviHp7FA3YcQu9yIIjNrHrDHM37xTpIlG
         2KDk+tTfyMBBumxuGVbgaqFU7Q+2lGQAxyWPuX65gmHn8PyUogqOHh0cyGRg7AxueO
         kYs3N/9BULtzPxpbuPmbTYlEOLp2Kij1TG79hnLvqfspIRNcbm6fyMXprsmjzw+/FA
         xcEazb4wCeqhNeTroFoaolPiR1DtRMmN/EOyC4adXPZtQ/fTLW+/YxtS3lyHhgFWqx
         BsKzMlw6qSWIU64h4uh0/eb+PeiNRS0MKhomLGeQFDfY/BYcO8+mnefk1SZH5pdESU
         qAF0BUabpHXvA==
Message-ID: <2e5088eb8df4db5ea4d9c9f2862fc19c3bf186d4.camel@kernel.org>
Subject: Re: [PATCH] ceph: Convert from atomic_t to refcount_t on
 ceph_snap_realm->nref
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>,
        Yejune Deng <yejune.deng@gmail.com>
Date:   Sat, 17 Jul 2021 07:21:40 -0400
In-Reply-To: <1626516381-40440-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1626516381-40440-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-07-17 at 18:06 +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  fs/ceph/snap.c  | 15 ++++++++-------
>  fs/ceph/super.h |  3 ++-
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 4ac0606dcbd4..d4ec9c5118bd 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -68,14 +68,15 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>  	lockdep_assert_held(&mdsc->snap_rwsem);
>  
>  	dout("get_realm %p %d -> %d\n", realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)+1);
>  	/*
>  	 * since we _only_ increment realm refs or empty the empty
>  	 * list with snap_rwsem held, adjusting the empty list here is
>  	 * safe.  we do need to protect against concurrent empty list
>  	 * additions, however.
>  	 */
> -	if (atomic_inc_return(&realm->nref) == 1) {
> +	refcount_inc(&realm->nref);
> +	if (refcount_read(&realm->nref) == 1) {

The above is potentially racy as you've turned a single atomic operation
into two. Another task could come in and increment or decrement
realm->nref just after your recount_inc but before the refcount_read,
and then the read would show the wrong result.

FWIW, Yejune Deng (cc'ed) proposed a very similar patch a few months ago
that caused this regression:

    https://tracker.ceph.com/issues/50281

>  		spin_lock(&mdsc->snap_empty_lock);
>  		list_del_init(&realm->empty_item);
>  		spin_unlock(&mdsc->snap_empty_lock);
> @@ -121,7 +122,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  	if (!realm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	atomic_set(&realm->nref, 1);    /* for caller */
> +	refcount_set(&realm->nref, 1);    /* for caller */
>  	realm->ino = ino;
>  	INIT_LIST_HEAD(&realm->children);
>  	INIT_LIST_HEAD(&realm->child_item);
> @@ -209,8 +210,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
>  	lockdep_assert_held_write(&mdsc->snap_rwsem);
>  
>  	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (atomic_dec_and_test(&realm->nref))
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> +	if (refcount_dec_and_test(&realm->nref))
>  		__destroy_snap_realm(mdsc, realm);
>  }
>  
> @@ -221,8 +222,8 @@ void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
>  			 struct ceph_snap_realm *realm)
>  {
>  	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (!atomic_dec_and_test(&realm->nref))
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> +	if (!refcount_dec_and_test(&realm->nref))
>  		return;
>  
>  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6b6332a5c113..3abb00d7a0eb 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -2,6 +2,7 @@
>  #ifndef _FS_CEPH_SUPER_H
>  #define _FS_CEPH_SUPER_H
>  
> +#include <linux/refcount.h>
>  #include <linux/ceph/ceph_debug.h>
>  
>  #include <asm/unaligned.h>
> @@ -859,7 +860,7 @@ struct ceph_readdir_cache_control {
>  struct ceph_snap_realm {
>  	u64 ino;
>  	struct inode *inode;
> -	atomic_t nref;
> +	refcount_t nref;
>  	struct rb_node node;
>  
>  	u64 created, seq;

-- 
Jeff Layton <jlayton@kernel.org>

