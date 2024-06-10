Return-Path: <ceph-devel+bounces-1279-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F78901ECA
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jun 2024 12:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C44EBB25972
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jun 2024 10:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F994762D2;
	Mon, 10 Jun 2024 10:05:31 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6016A7440B;
	Mon, 10 Jun 2024 10:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718013930; cv=none; b=UOgBePrgZRIwu8NzpmF54MXlSKEWMvbv5/WkXkfh4gi0cHTIiH+ic1rKPNkZaeVPhkYYmSM+yBln3ntaTJ9nMG3PxrQDpvOe6LcZML0HtalufS1NuTed4hvXznh3nOCUyATzL5hEjbW9IQl7KLcqC9z51IE3HyJq3wv4fOIuZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718013930; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcwovGbOjZ/DjERlD9sBk3EIHk1cTKD1cjLKT9UxALh8jvM1EGnu4H2M7ODyrj8Rn9b4+tKU4z8PMyxzqSRP1tVH2RVil7wMKDNFcNdnzuOd0Bw4xD0pil+H7uoY9Zjzu04sgDt6mPpZKBAoKOL32g4UtyNwB8n3B/2j7k6S9M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4214b2c5d40so1077835e9.1;
        Mon, 10 Jun 2024 03:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718013928; x=1718618728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=xBD9mJ7xVNPuVOng5/cWhKhPNjeo4zSN2W8S+WkJGkJo+xD4kpTp+pzh2+B/gDqOf3
         /2k6fUntEK7of8LrY7tCq+uM8OqENSUg+GIhPEsKyPo3Mt6xtnaGCRt58qf5vO2v78be
         e5TVIZd+2bp3XlNWOcc+TAfWbrrpwEOb2Jycd6RW6Mw4FzNHCe7knxoDE79sIQSXPDK7
         XeT7gI1mlnELoxP2RXzxeVCX9oa1xwoN2raZ6BFva2dDfxMQamXaRSTRLOsWwcTYjhgP
         JkqePmhM1TxnAtlvptDH51FwteSqfIhMxmPZvk4UshGSJ9bZ7DWXSWX9S7jRImUBHFLg
         TaBw==
X-Forwarded-Encrypted: i=1; AJvYcCXTaM7F7awugZtTjXKyfTombzdqOyM5xwMW2Xct38JTZIjvhbx3NDxjhRfGd364VPGxUJwpmlSrKgbHPb0h/ZgL3EHu7kEbYIqjnZ6c2z4X7H4nocy/X+vwvsMOoY4ZEBfxjMcJCq9IRYhnkQgQP4mE9bYlKD/UqEyRx5511u2/
X-Gm-Message-State: AOJu0YwedKKMLpeIKzTyC1PTDpzb140LH7YQeRFYwqhGArkkqk88OkHO
	HopoHDPHqOYz8J2uPL23UilulyhIjhlN2qTSgloQIyM03lnjmPP8
X-Google-Smtp-Source: AGHT+IHd2ytfSWQRZyhEMoJ4OHwdV5oY+VtFMa+gkpFCCXHA6mdBcbjzpIbfF3YSe0sE3AJLKSZkJQ==
X-Received: by 2002:a05:600c:5104:b0:421:7f30:7ccb with SMTP id 5b1f17b1804b1-4217f307f48mr32593165e9.1.1718013927623;
        Mon, 10 Jun 2024 03:05:27 -0700 (PDT)
Received: from [10.50.4.180] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4217ff85ca6sm59795885e9.14.2024.06.10.03.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jun 2024 03:05:27 -0700 (PDT)
Message-ID: <35b55da5-deb5-4899-852f-7f0f30198adb@grimberg.me>
Date: Mon, 10 Jun 2024 13:05:25 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] nvme-tcp: use sendpages_ok() instead of
 sendpage_ok()
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 Hannes Reinecke <hare@suse.de>
References: <20240606161219.2745817-1-ofir.gal@volumez.com>
 <20240606161219.2745817-3-ofir.gal@volumez.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240606161219.2745817-3-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>


