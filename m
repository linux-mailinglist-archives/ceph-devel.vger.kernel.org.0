Return-Path: <ceph-devel+bounces-1560-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF84B93BE26
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 10:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95B0B22D44
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 08:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B06190063;
	Thu, 25 Jul 2024 08:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kgCH4ewv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F9C190045
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 08:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721897189; cv=none; b=CT2WBPsbAqk/HatCGx9wBmEO81/QxntcDZhzCftyCtsZ5eVy07p/VWis8UTUuJxK+wMWZTM7mSgcjBz95cXxvWjtlSkH/WFgGAYXWf7NQobOthxi+YpuwuTT1gIUSiELgQpPikXOmmaANiV7WqTXIteCuwY2Ohrbxze/WedztKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721897189; c=relaxed/simple;
	bh=6Unbf2IkB+/ToIza3Uw317a89w2HFf4IhKGsVD3vIgw=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YOgLjn0yELBJc+Fbx/Z076IX4Qrdp9j/lpwJGTlgvuZcAOZkdJhRWEidYAgk18he9+pBJvS/yzxNb4/Df1ig5TaYpJ7fIJrMuFGNfS++jPDYnHufzMkL6/76tBcjjlt8lBRsxW1AbZaH/uoYXE0fEwd1+1Zu2hJuccfTlAIvvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kgCH4ewv; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Subject: Re: [PATCH 1/3] rbd: rename RBD_LOCK_STATE_RELEASING and
 releasing_wait
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721897182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3HPJgSqOpNO9/U/b/EDCG1KWzJfAy+KVGw5P46cz6L8=;
	b=kgCH4ewvHQWBUtW9YF73d0K3nRN3IbVKabNif58oIAaoZ07raCUKoI7Z5kCX0xzjBT/EeM
	67oCtKE0VnpnsvU7qFBQiMxEJLegGfaXIvc5qqWXr616EMpnUzZ/9MXKLCbKNE1b6vxw3G
	KHHpeXTKHiKUftYJlDEu3IGgj6TWTe8=
To: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20240724062914.667734-1-idryomov@gmail.com>
 <20240724062914.667734-2-idryomov@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
Message-ID: <eaaa29e9-0a3a-facb-cd46-fde4a4be1b9a@linux.dev>
Date: Thu, 25 Jul 2024 16:46:13 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240724062914.667734-2-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2024/7/24 星期三 下午 2:29, Ilya Dryomov 写道:
> ... to RBD_LOCK_STATE_QUIESCING to quiescing_wait to recognize that

Hi Ilya,
   s/to quiescing_wait/and quiescing_wait

Otherwise:

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>


> this state and the associated completion are backing rbd_quiesce_lock(),
> which isn't specific to releasing the lock.
> 
> While exclusive lock does get quiesced before it's released, it also
> gets quiesced before an attempt to update the cookie is made and there
> the lock is not released as long as ceph_cls_set_cookie() succeeds.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 9c6cff54831f..77a9f19a0035 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -362,7 +362,7 @@ enum rbd_watch_state {
>   enum rbd_lock_state {
>   	RBD_LOCK_STATE_UNLOCKED,
>   	RBD_LOCK_STATE_LOCKED,
> -	RBD_LOCK_STATE_RELEASING,
> +	RBD_LOCK_STATE_QUIESCING,
>   };
>   
>   /* WatchNotify::ClientId */
> @@ -422,7 +422,7 @@ struct rbd_device {
>   	struct list_head	running_list;
>   	struct completion	acquire_wait;
>   	int			acquire_err;
> -	struct completion	releasing_wait;
> +	struct completion	quiescing_wait;
>   
>   	spinlock_t		object_map_lock;
>   	u8			*object_map;
> @@ -525,7 +525,7 @@ static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
>   	lockdep_assert_held(&rbd_dev->lock_rwsem);
>   
>   	return rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED ||
> -	       rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING;
> +	       rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING;
>   }
>   
>   static bool rbd_is_lock_owner(struct rbd_device *rbd_dev)
> @@ -3458,12 +3458,12 @@ static void rbd_lock_del_request(struct rbd_img_request *img_req)
>   	spin_lock(&rbd_dev->lock_lists_lock);
>   	if (!list_empty(&img_req->lock_item)) {
>   		list_del_init(&img_req->lock_item);
> -		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
> +		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING &&
>   			       list_empty(&rbd_dev->running_list));
>   	}
>   	spin_unlock(&rbd_dev->lock_lists_lock);
>   	if (need_wakeup)
> -		complete(&rbd_dev->releasing_wait);
> +		complete(&rbd_dev->quiescing_wait);
>   }
>   
>   static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
> @@ -4181,16 +4181,16 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
>   	/*
>   	 * Ensure that all in-flight IO is flushed.
>   	 */
> -	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
> -	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
> +	rbd_dev->lock_state = RBD_LOCK_STATE_QUIESCING;
> +	rbd_assert(!completion_done(&rbd_dev->quiescing_wait));
>   	if (list_empty(&rbd_dev->running_list))
>   		return true;
>   
>   	up_write(&rbd_dev->lock_rwsem);
> -	wait_for_completion(&rbd_dev->releasing_wait);
> +	wait_for_completion(&rbd_dev->quiescing_wait);
>   
>   	down_write(&rbd_dev->lock_rwsem);
> -	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
> +	if (rbd_dev->lock_state != RBD_LOCK_STATE_QUIESCING)
>   		return false;
>   
>   	rbd_assert(list_empty(&rbd_dev->running_list));
> @@ -5383,7 +5383,7 @@ static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
>   	INIT_LIST_HEAD(&rbd_dev->acquiring_list);
>   	INIT_LIST_HEAD(&rbd_dev->running_list);
>   	init_completion(&rbd_dev->acquire_wait);
> -	init_completion(&rbd_dev->releasing_wait);
> +	init_completion(&rbd_dev->quiescing_wait);
>   
>   	spin_lock_init(&rbd_dev->object_map_lock);
>   
> 

