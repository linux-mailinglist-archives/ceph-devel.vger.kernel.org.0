Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E52AABD2
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Nov 2020 16:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKHPPM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 8 Nov 2020 10:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727844AbgKHPPL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 8 Nov 2020 10:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604848510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCiEM7AQz5QZ2RvY5C0nr85g19BsqN3bEHGGJWjun8g=;
        b=REGghAwvDG700XxvFoEua2gT/PxE7PR+OMgmuToJtos0TbUsFc02pLoUFyg5u9TQ6GTd0A
        n2qVLz8dMOc4QT5AipGmGCRZLazwmkyyRNOI5YOh3w3XFNLLFv4FhPz+BkhcnUxXhI8aJz
        0KdtWMnG4Kk3tZ5ava30mnW7p3HOdPk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-NUXJCL0JP_SRZR3N7RCaxQ-1; Sun, 08 Nov 2020 10:15:08 -0500
X-MC-Unique: NUXJCL0JP_SRZR3N7RCaxQ-1
Received: by mail-wr1-f70.google.com with SMTP id f4so9235wru.21
        for <ceph-devel@vger.kernel.org>; Sun, 08 Nov 2020 07:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xCiEM7AQz5QZ2RvY5C0nr85g19BsqN3bEHGGJWjun8g=;
        b=lHEIldBweD+xLMjSc5IeJxosI0qitjehfM4xdRWxxctvr724nB3AsNJDAwM1bqPNZ8
         agJnN4fEVVZK8mhnEGIinPmVHP/UgD26Yb1vl1Mn581+rtiYPrZnjzU3k31xTZPhOcUt
         scaRTVuiF9auzRDZnDiwA7Qul9LOclONXdV1bFQxFE3l7uwRg90yCXpjnr7V4kLVEmTm
         qpg5A4OfTRehQnWLs/sT1l2LtB9+wPSbTca6RnqkQtsgauobbp04meXh4egIxiquQHyY
         FLErBbqN4W2lrmt4pNiklYSwBMKZaxEE4tWk/S09T4wIboju5MXXyLbrrS+mUTt4XRg+
         UL6A==
X-Gm-Message-State: AOAM530UDgaRmnkxCoXJZV9pJIZgVc0sjKYs4OuvoyRQB1jPuWxGN9s6
        DD+C4Eir0Xwlae91ZdLNDORJNvU8jm5z1SqJ5N3W4Wj1m4o7MpNKDmuGlNZoURcpvjyKquOmbT0
        jbaML2x4Ki2+tXdAbRpOXIw==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr10142621wmd.139.1604848507890;
        Sun, 08 Nov 2020 07:15:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBz6wtcRAgwxrEGiAL8ElHcOzDdD7qQjz/7QuIFGOGrDkKJazoMrCqH8844xWODBZg8NNGyg==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr10142589wmd.139.1604848507695;
        Sun, 08 Nov 2020 07:15:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l3sm11508325wmg.32.2020.11.08.07.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 07:15:06 -0800 (PST)
Subject: Re: [PATCH 23/24] virtio-blk: remove a spurious call to
 revalidate_disk_size
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20201106190337.1973127-1-hch@lst.de>
 <20201106190337.1973127-24-hch@lst.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d23bd50a-7555-438b-9e3b-131414b2d1a5@redhat.com>
Date:   Sun, 8 Nov 2020 16:15:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106190337.1973127-24-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 06/11/20 20:03, Christoph Hellwig wrote:
> revalidate_disk_size just updates the block device size from the disk 
> size. Thus calling it from revalidate_disk_size doesn't actually do 

s/revalidate_disk_size/virtblk_update_cache_mode/

> anything.

