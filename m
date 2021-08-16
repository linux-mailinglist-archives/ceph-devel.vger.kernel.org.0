Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF143EDB44
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 18:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhHPQvu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 12:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhHPQvt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Aug 2021 12:51:49 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F72C0617AF
        for <ceph-devel@vger.kernel.org>; Mon, 16 Aug 2021 09:51:16 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id n27so2967335oij.0
        for <ceph-devel@vger.kernel.org>; Mon, 16 Aug 2021 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lkHKKxx6E91blWpox1bXj/LIePIAFS6deUe/aal8ts0=;
        b=2M7PsQmoW0m68H0tIVJvrAROv1UoWp/uy48nnzobRrc03mo4J/lqcPLEQEF1kpJUHw
         HQBa4gX5fuTsQap76AZD/5O7VV8iT7vusfHhUAUKN78fP0BZSnTbz5bFFrpuEHica0IG
         vNOnPFWucI7QTNpQA0kxldWWTEaok+vCXtpMF9OBhganoAYTPaU0jWc3pk2ipYfiP3qw
         KJv7dYM9ZKsD48MEvHmMnjHIhntqyqYB/aLy5wa1Nk3VqVwfnK6sD7DQ+glML2iy7RW5
         8bKOFtNVZE+7XBNUsAmXKRXSN7yXiZDUd4eqzd5A6g+KiYc52tKP/BJj3qVXfxUmmZ/Y
         b/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lkHKKxx6E91blWpox1bXj/LIePIAFS6deUe/aal8ts0=;
        b=LijtEE5KL7P5468lgc1oLVzUJ+67j0T0d4ZVRaYnT4So/oPCFDjvjr9Xc6BsNPE0O/
         4FjK02jVg/wfoXj8zAHTaGkm1fTz6iWsk5DHoCQZXKm3IHS5ijT7wmU7qULua8FY6W5k
         6LQbCEgNB+b1ytyGwPxNTUggYQnIgJ9Jn6fG3hMDbxezoKzfVP5tMa/pJUNuK1yexJTO
         UXeTtYWD27NE+aMvWXtSaYVIBuP3cvb3NM2dLUiIPRYYMe5lAqXI78k5C1NIHGRGNsft
         sxxNA99VsRHJLYEzwUlNV+88TSDcXWmoqioApRf10+ZA2Dm+v/Jw5wgSgQ54Yp6qm0rj
         4Clw==
X-Gm-Message-State: AOAM530XzjBg/L5mRNJY2z4v0RRWSfMP4jh2KQZ99f5ZDHNXwoopziEO
        MFDJ2l7xioAmoAcONAfNtK7Vcg==
X-Google-Smtp-Source: ABdhPJwPiJZucbHV+gTb5R7I/kfPLblHKKXb+EIub7hcvBOP41sFKxi/Q6epHu0YRXyVvO62JSl/PA==
X-Received: by 2002:a54:4619:: with SMTP id p25mr42850oip.5.1629132675579;
        Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u18sm2018498ooi.40.2021.08.16.09.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
Subject: Re: add a bvec_virt helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210804095634.460779-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4e321dab-188d-ca0a-a98c-4a587e7b5f27@kernel.dk>
Date:   Mon, 16 Aug 2021 10:51:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 8/4/21 3:56 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series adds a bvec_virt helper to return the virtual address of the
> data in bvec to replace the open coded calculation, and as a reminder
> that generall bio/bvec data can be in high memory unless it is caller
> controller or in an architecture specific driver where highmem is
> impossible.

Applied, thanks.

-- 
Jens Axboe

