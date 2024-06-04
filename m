Return-Path: <ceph-devel+bounces-1262-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14DE18FB318
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 15:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82F8D1F23EE1
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 13:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A217145B27;
	Tue,  4 Jun 2024 13:01:24 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E82A1E519;
	Tue,  4 Jun 2024 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506083; cv=none; b=uDaq9x1VYvihMHtckHa4ya2ZdVc7P14j2vhITmbCD2w7wrMuN/qd7j/gD+G3QSAivForJjs9DFaNuXnhSxoRUd+V3cQSfqM570fwUO1LgnbJhiYfEL//dxR06t8bm/YO0HBNIHN9tFnslBX4NI+wAer/Z8pTvVrZLmaU5ebIqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506083; c=relaxed/simple;
	bh=q4Tr+AFR+WP7AGPpqaG/QKSTCGhZPx0fb7JxJHtzMi4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lR+4plt67IxgOc3pqXqUwgzkzkGaUR2LArIUsV48NeTFfqKcUPQJMNmqC9USnC+sN92laimjOC0KkM2NUgLpb9uBvGX8SKCfBCGYzRLiNXj+vkFDZxCkUIEfvRA3mKU4IRzO1fFN/p/XSuBhBYT+dmQpB4KNePaeP3n6VGIroTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4210f0bb857so5430995e9.1;
        Tue, 04 Jun 2024 06:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717506080; x=1718110880;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxHXs7IG64cFNSoqIPh3h+fcJrQqZkul2851soVpEBU=;
        b=jH4RvCan+YDykSraSvJTsPODWwtXC1CHh+ImZ9HUJXKtlRaYz6MYuKvm+OetM9B0Mg
         dPtWv2fGYE3T9Ubp+YcDJNB7LVMoIWShsjmFeSgOsx+grvVGsO4kX0UCpS60weOxKAiS
         fPRTkSKGghQF02aVUJxHXC4q6WhuKQmqpj2shDehZuq0L29KdRgwalyMNB7oqeU+Fmo1
         9kWQtiD1C3k8fLjNrvSot9YQ1jQB9z8AjpR3e2gK340ITN1ZjsScaqfAo/RjeOjLYnVA
         OBt+V7rjI9z93jS9bcdzhTUFg28Wo3OPUWoxlYx0NSFKB8AThIfrlsiql20PfT5Dadg7
         aTIA==
X-Forwarded-Encrypted: i=1; AJvYcCVKY9qkCW7DgRJzbcxuEzkxAukpz/WY1DZQyJplZG39n2ozKaASv1daGPi/pRGm05YdBgxtt9Yi0ndhjWdBCM3Pa3/u9A01mvZos02rVfyceKUZ/KleYYZGkitdAvHupn4Lu7d19YBL/T6PtgA47SE0Gsh7F49yXqp8T8mFEPNF
X-Gm-Message-State: AOJu0Yx6TjGEcTVnoy+LbNDyW8jZHkB2+aCMEO5h47OI4Ph9bKFTjIaT
	ufUpF9GkPRDU76e3ghrCpQFyV+7dGbSB+xO3bd833LW+qqpSnmUP
X-Google-Smtp-Source: AGHT+IH9oq3dFpvLJVUKgEQQ0Vx9YEe7q6Q5Zb8A/OQIgbPFG2wSdi0d9xEzXrAJ0zX69KHy0U2C2g==
X-Received: by 2002:a05:600c:1382:b0:41b:fdf9:98b5 with SMTP id 5b1f17b1804b1-4212e0c40a5mr92270135e9.4.1717506080292;
        Tue, 04 Jun 2024 06:01:20 -0700 (PDT)
Received: from [10.50.4.180] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421542e207esm13638365e9.22.2024.06.04.06.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 06:01:20 -0700 (PDT)
Message-ID: <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me>
Date: Tue, 4 Jun 2024 16:01:17 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
From: Sagi Grimberg <sagi@grimberg.me>
To: Christoph Hellwig <hch@lst.de>
Cc: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
 <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
 <20240604042738.GA28853@lst.de>
 <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
Content-Language: en-US
In-Reply-To: <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 04/06/2024 11:24, Sagi Grimberg wrote:
>
>
> On 04/06/2024 7:27, Christoph Hellwig wrote:
>> On Tue, Jun 04, 2024 at 12:27:06AM +0300, Sagi Grimberg wrote:
>>>>> I still don't understand how a page in the middle of a contiguous 
>>>>> range ends
>>>>> up coming from the slab while others don't.
>>>> I haven't investigate the origin of the IO
>>>> yet. I suspect the first 2 pages are the superblocks of the raid
>>>> (mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the 
>>>> bitmap.
>>> Well, if these indeed are different origins and just *happen* to be a
>>> mixture
>>> of slab originated pages and non-slab pages combined together in a 
>>> single
>>> bio of a bvec entry,
>>> I'd suspect that it would be more beneficial to split the bvec 
>>> (essentially
>>> not allow bio_add_page
>>> to append the page to tail bvec depending on a queue limit (similar 
>>> to how
>>> we handle sg gaps).
>> So you want to add a PageSlab check to bvec_try_merge_page? That sounds
>> fairly expensive..
>>
>
> The check needs to happen somewhere apparently, and given that it will 
> be gated by a queue flag
> only request queues that actually needed will suffer, but they will 
> suffer anyways...

Something like the untested patch below:
--
diff --git a/block/bio.c b/block/bio.c
index 53f608028c78..e55a4184c0e6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -18,6 +18,7 @@
  #include <linux/highmem.h>
  #include <linux/blk-crypto.h>
  #include <linux/xarray.h>
+#include <linux/net.h>

  #include <trace/events/block.h>
  #include "blk.h"
@@ -960,6 +961,9 @@ bool bvec_try_merge_hw_page(struct request_queue *q, 
struct bio_vec *bv,
                 return false;
         if (len > queue_max_segment_size(q) - bv->bv_len)
                 return false;
+       if (q->limits.splice_pages &&
+           sendpage_ok(bv->bv_page) ^ sendpage_ok(page))
+                       return false;
         return bvec_try_merge_page(bv, page, len, offset, same_page);
  }

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a7e820840cf7..82e2719acb9c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1937,6 +1937,7 @@ static void nvme_set_ctrl_limits(struct nvme_ctrl 
*ctrl,
         lim->virt_boundary_mask = NVME_CTRL_PAGE_SIZE - 1;
         lim->max_segment_size = UINT_MAX;
         lim->dma_alignment = 3;
+       lim->splice_pages = ctrl->splice_pages;
  }

  static bool nvme_update_disk_info(struct nvme_ns *ns, struct 
nvme_id_ns *id,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 3f3e26849b61..d9818330e236 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -398,6 +398,7 @@ struct nvme_ctrl {

         enum nvme_ctrl_type cntrltype;
         enum nvme_dctype dctype;
+       bool splice_pages
  };

  static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 02076b8cb4d8..618b8f20206a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2146,6 +2146,12 @@ static int nvme_tcp_configure_admin_queue(struct 
nvme_ctrl *ctrl, bool new)
         if (error)
                 goto out_stop_queue;

+       /*
+        * we want to prevent contig pages with conflicting 
splice-ability with
+        * respect to the network transmission
+        */
+       ctrl->splice_pages = true;
+
         nvme_unquiesce_admin_queue(ctrl);

         error = nvme_init_ctrl_finish(ctrl, false);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69c4f113db42..ec657ddad2a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -331,6 +331,12 @@ struct queue_limits {
          * due to possible offsets.
          */
         unsigned int            dma_alignment;
+
+       /*
+        * Drivers that use MSG_SPLICE_PAGES to send the bvec over the 
network,
+        * will need either bvec entry contig pages spliceable or not.
+        */
+       bool                    splice_pages;
  };

  typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
--

What I now see is that we will check PageSlab twice (bvec last index and 
append page)
and skb_splice_from_iter checks it again... How many times check we 
check this :)

Would be great if the network stack can just check it once and fallback 
to page copy...

