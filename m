Return-Path: <ceph-devel+bounces-1510-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD7692CC80
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 10:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ADC51C22D4A
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 08:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE4C82C60;
	Wed, 10 Jul 2024 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mh0zp9wo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D784A4C
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720598873; cv=none; b=FS3of9a6lxbBJTIn8i+94j4enrEOmmnvw1BaQtfbFkIv8AzpUoF6fGGYP1QdiHKeBgADhnrYzc7vKebrlTCKCXiLBzCLOzxp37XXzSm3y+IQOYo3WPTj7fHRkbJlXDJXNCZBNulwTiHZN9YjtuutJkH9G7+652DfDM0WhKruNt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720598873; c=relaxed/simple;
	bh=ASNuKrP/PeHMdoWeT0E/5fD1PJc05aGWIH3hpQVPpBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rWWnsfckHU4gg8KLTh9S+Dg3976+Jdp3U7JBtZN6AUVLXBq6/huOmsYwyxdf0G+iSgNWSzn2UK0KviazpvAVga9bjXRXPUa0P9ayNJJrXxvO/ZpwIf1G53jkBxP/BRIrdc26hDo7Q7lNBif5wBDpX0AGUDI1XOAhKPnlZVhTi6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mh0zp9wo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720598870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPNSRcMtH4iaaxEw8ypc0998Qn1lR48bRufcJySS2GI=;
	b=Mh0zp9woqPdA5h9OFKIbrhI9wzaI/RBEuwYlcsUn5YoocN0DNduelKsHuORnE1qMMKLfAM
	tsn0okjKQo9+z3uoREsU8OGZ36DduWhmTWe3q6Tv0BJ9VsJN+vUcboM+UVaCq0gPs9hxnM
	g1ufmmdlJQuvPsWu5aSGA/1XDU5meWQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-FFr9BgiMOwO6SejN1tYh8g-1; Wed, 10 Jul 2024 04:07:43 -0400
X-MC-Unique: FFr9BgiMOwO6SejN1tYh8g-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-70b12d4d4f4so4591054b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 01:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720598862; x=1721203662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPNSRcMtH4iaaxEw8ypc0998Qn1lR48bRufcJySS2GI=;
        b=kax4L4ZuI/zct9ZSBSGgexkob6tFlLe23OUVx9uWsbv6lrACN8v9FcC14OVPBWUeb4
         aJQ+LPXR2faY5LWH6eNjh/a4N+T9gOPIjxuulh2ArnvOyAy8ZBO6Zx+O3xPDzkR32/q0
         8SV4tIsWv5ktQS8yrnve11IZU5C/lXSUYKU8ltugDjVGfGOohVNvIk4IQ9aXCdImASFG
         ufMDBf3AI8RWcrZndiuJxwtOVtjk1VqaNBj5hYkVmZ9u5u4uEDylvNZfRlhqzEUQytRf
         ihOlhQubbz1XB7vUsD+ekwJmsDq/MxLvgihhT3BRASmiP2lVrUWrUfMqfhxRszUx5mnf
         PPLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIfOqKeuydCnh8u7mZ8qCH/Qd8pCr0jcft9ZcpUINobbSRDu14xURVdiOmZzGhgEo/01OPfIc/hN+nIqvAGshedNe1gq8heANvJg==
X-Gm-Message-State: AOJu0YxkzK+tmEdTBAqRZU06wR0S8NvEebGiw3wPvE8JVYondrFNv8mZ
	w0JQb31IRp9orUR9zIJOZ9opwHxLMtXc4a+ZYzGUzj5he477/P+OgO8nKqkyt9kyKxXRdVPjxvh
	CQD31Nqphz0eBbZz0w8FUMh2XGNReukmpeL1P021bb+oVKSpXnMk1DKzGrjfK0A1RTKZR4Q==
X-Received: by 2002:a05:6a00:1388:b0:705:c30d:d6c3 with SMTP id d2e1a72fcca58-70b4353c1b9mr5756454b3a.11.1720598862308;
        Wed, 10 Jul 2024 01:07:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwnuAOdQpowON6XhWWALzEY5TjlH3nyVj9Sie7jwSC+Fz0EaHcXPzTwK5va/NWqCwyS/NDIQ==
X-Received: by 2002:a05:6a00:1388:b0:705:c30d:d6c3 with SMTP id d2e1a72fcca58-70b4353c1b9mr5756438b3a.11.1720598861920;
        Wed, 10 Jul 2024 01:07:41 -0700 (PDT)
Received: from [10.72.116.145] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b43898c52sm3137934b3a.23.2024.07.10.01.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 01:07:41 -0700 (PDT)
Message-ID: <78a10697-341a-4c5b-ae05-6a261448b89c@redhat.com>
Date: Wed, 10 Jul 2024 16:07:37 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libceph: fix race between delayed_work() and
 ceph_monc_stop()
To: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20240709113848.336103-1-idryomov@gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240709113848.336103-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/9/24 19:38, Ilya Dryomov wrote:
> The way the delayed work is handled in ceph_monc_stop() is prone to
> races with mon_fault() and possibly also finish_hunting().  Both of
> these can requeue the delayed work which wouldn't be canceled by any of
> the following code in case that happens after cancel_delayed_work_sync()
> runs -- __close_session() doesn't mess with the delayed work in order
> to avoid interfering with the hunting interval logic.  This part was
> missed in commit b5d91704f53e ("libceph: behave in mon_fault() if
> cur_mon < 0") and use-after-free can still ensue on monc and objects
> that hang off of it, with monc->auth and monc->monmap being
> particularly susceptible to quickly being reused.
>
> To fix this:
>
> - clear monc->cur_mon and monc->hunting as part of closing the session
>    in ceph_monc_stop()
> - bail from delayed_work() if monc->cur_mon is cleared, similar to how
>    it's done in mon_fault() and finish_hunting() (based on monc->hunting)
> - call cancel_delayed_work_sync() after the session is closed
>
> Cc: stable@vger.kernel.org
> Link: https://tracker.ceph.com/issues/66857
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   net/ceph/mon_client.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index f263f7e91a21..ab66b599ac47 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1085,13 +1085,19 @@ static void delayed_work(struct work_struct *work)
>   	struct ceph_mon_client *monc =
>   		container_of(work, struct ceph_mon_client, delayed_work.work);
>   
> -	dout("monc delayed_work\n");
>   	mutex_lock(&monc->mutex);
> +	dout("%s mon%d\n", __func__, monc->cur_mon);
> +	if (monc->cur_mon < 0) {
> +		goto out;
> +	}
> +
>   	if (monc->hunting) {
>   		dout("%s continuing hunt\n", __func__);
>   		reopen_session(monc);
>   	} else {
>   		int is_auth = ceph_auth_is_authenticated(monc->auth);
> +
> +		dout("%s is_authed %d\n", __func__, is_auth);
>   		if (ceph_con_keepalive_expired(&monc->con,
>   					       CEPH_MONC_PING_TIMEOUT)) {
>   			dout("monc keepalive timeout\n");
> @@ -1116,6 +1122,8 @@ static void delayed_work(struct work_struct *work)
>   		}
>   	}
>   	__schedule_delayed(monc);
> +
> +out:
>   	mutex_unlock(&monc->mutex);
>   }
>   
> @@ -1232,13 +1240,15 @@ EXPORT_SYMBOL(ceph_monc_init);
>   void ceph_monc_stop(struct ceph_mon_client *monc)
>   {
>   	dout("stop\n");
> -	cancel_delayed_work_sync(&monc->delayed_work);
>   
>   	mutex_lock(&monc->mutex);
>   	__close_session(monc);
> +	monc->hunting = false;
>   	monc->cur_mon = -1;
>   	mutex_unlock(&monc->mutex);
>   
> +	cancel_delayed_work_sync(&monc->delayed_work);
> +
>   	/*
>   	 * flush msgr queue before we destroy ourselves to ensure that:
>   	 *  - any work that references our embedded con is finished.

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


