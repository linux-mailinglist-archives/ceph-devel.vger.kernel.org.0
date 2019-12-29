Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CD12BFDA
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Dec 2019 02:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL2BYe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 28 Dec 2019 20:24:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41509 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726187AbfL2BYe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 28 Dec 2019 20:24:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577582673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9EFHDYj8VdY8XUwBvRdGcSZCmQi6vUH8JCdWZNqW0gY=;
        b=aX4omuBcXTpRIsGiELVrLHskExrG3uNt0zBspWsfHC1uA3x24VdWJuVxHq763RHuy2JJzK
        4uyeaJ/37cfKtHcEY5andQ+iUqD9/xcEG71CyVCP5U8FRS1X5xt1PABmZ7AWmXe2RUGnSx
        NKVuJI4mf9kSobj27L6IgQP0aE7KOHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-tNCz571lMGGY3RTARv7EbQ-1; Sat, 28 Dec 2019 20:24:31 -0500
X-MC-Unique: tNCz571lMGGY3RTARv7EbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF813107ACC4;
        Sun, 29 Dec 2019 01:24:30 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E122108131B;
        Sun, 29 Dec 2019 01:24:25 +0000 (UTC)
Subject: Re: [PATCH 3/4] ceph: periodically send cap and dentry lease perf
 metrics to MDS
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191224040514.26144-1-xiubli@redhat.com>
 <20191224040514.26144-4-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b5beb870-098b-6495-f519-e9331e078653@redhat.com>
Date:   Sun, 29 Dec 2019 09:24:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191224040514.26144-4-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/24 12:05, xiubli@redhat.com wrote:
> +
> +	head = msg->front.iov_base;
> +
> +	/* encode the cap metric */
> +	cap = (struct ceph_metric_cap *)(head + 1);
> +	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> +	cap->ver = 1;
> +	cap->campat = 1;
> +	cap->data_len = cpu_to_le32(sizeof(*cap) - 6);

s/6/10/, the data_len shouldn't include the data_len itself.

Will fix it in V2.

> +	cap->hit = cpu_to_le64(percpu_counter_sum(&s->i_caps_hit));
> +	cap->mis = cpu_to_le64(percpu_counter_sum(&s->i_caps_mis));
> +	cap->total = cpu_to_le64(s->s_nr_caps);
> +	items++;
> +
> +	dout("cap metric type %d, hit %lld, mis %lld, total %lld",
> +	     cap->type, cap->hit, cap->mis, cap->total);
> +
> +	/* only send the global once */
> +	if (skip_global)
> +		goto skip_global;
> +
> +	/* encode the dentry lease metric */
> +	lease = (struct ceph_metric_dentry_lease *)(cap + 1);
> +	lease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> +	lease->ver = 1;
> +	lease->campat = 1;
> +	lease->data_len = cpu_to_le32(sizeof(*cap) - 6);
Same here.
> +	lease->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit));
> +	lease->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis));
> +	lease->total = cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries));
> +	items++;
> +

