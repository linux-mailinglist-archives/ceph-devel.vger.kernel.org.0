Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26EE2C7C56
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Nov 2020 02:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgK3BYS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 20:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgK3BYR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 20:24:17 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F81C0613CF
        for <ceph-devel@vger.kernel.org>; Sun, 29 Nov 2020 17:23:31 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id z14so9768005ilm.10
        for <ceph-devel@vger.kernel.org>; Sun, 29 Nov 2020 17:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BZmTZBqdpz8QAbNwD292cR5AKXCzTrvi1V4QZo4ASiQ=;
        b=hKnZYq2zYwBXSBj9NeRqd6+7PYTZURDvcmLIwor4SOQougjRYVBJjKQib8Bw+L+jyj
         hK29uuv0S3/5uH5/Y9KJob1/oXpFwwBro0asfQc1NQg3uLi60wqboim7OnzakiprgxjY
         vJ6Y2TDWIlzHPhC/HWJUs0MGAoR5NIq4xHju0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BZmTZBqdpz8QAbNwD292cR5AKXCzTrvi1V4QZo4ASiQ=;
        b=R/FImB9UmUprP/G0Kgx1f9cvJbc9M2LOuGs71vuZ6VVWqMxSCVGYR4VpkMVF5dehNq
         vW4kRXdYycD21EmYgrNM5J4QSL3zC0UyG0aBiesP1Fa9uJLwy67JTikLQLgm0uiRLRFR
         h/MZqTUU0BmTrEgpPSlwthNNF6RvAMFPBt8KjUY84Rx+esU2Fsm78oul9uJ31oZYQeyS
         ZuWQo24RUzoYwLZE9jf6pl5Cnp/U0ecTgWhGdQhvgYeDbGDmH3bYWWLtaZbFI1uFDj2R
         6LghUYt9CMhJb19AufsH8CXONqFjQ7adYv0jLVSz6YVo184RztzYjskSNY3FcNHaIKkX
         AsCQ==
X-Gm-Message-State: AOAM531woKIOhHaB+VFgubd72xx5TJNgamZjnS+Nww1Lqlw3YT+ahu5j
        TPjN3rG3Gm76qCYazXOMENIlwQ==
X-Google-Smtp-Source: ABdhPJx6pfJfEezIuUrTQnLZt8wZNJbVHV799bmuRFAi7zQbwNigfx6jMUois48aZKI1igPQUl300Q==
X-Received: by 2002:a92:84c1:: with SMTP id y62mr16165882ilk.191.1606699411252;
        Sun, 29 Nov 2020 17:23:31 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id n10sm7216731iom.36.2020.11.29.17.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 17:23:30 -0800 (PST)
Subject: Re: [PATCH 1/4] block: add a hard-readonly flag to struct gendisk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20201129181926.897775-1-hch@lst.de>
 <20201129181926.897775-2-hch@lst.de>
From:   Alex Elder <elder@ieee.org>
Message-ID: <44c60506-059f-f272-208f-a39d94a8617d@ieee.org>
Date:   Sun, 29 Nov 2020 19:23:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/29/20 12:19 PM, Christoph Hellwig wrote:
> Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
> partition") addressed a long-standing problem with user read-only

Little nit I noticed below.	-Alex

. . .

> diff --git a/block/genhd.c b/block/genhd.c
> index 565cf36a5f1864..5e746223b6fa0f 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1625,31 +1625,35 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> -void set_disk_ro(struct gendisk *disk, int flag)
> +/**
> + * set_disk_ro - set a gendisk read-only
> + * @disk:	The disk device
> + * @state:	true or false

s/state/read_only/

> + *
> + * This function is used to indicate whether a given disk device should have its
> + * read-only flag set. set_disk_ro() is typically used by device drivers to
> + * indicate whether the underlying physical device is write-protected.
> + */
> +void set_disk_ro(struct gendisk *disk, bool read_only)

. . .


