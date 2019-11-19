Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2254101E91
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSIuh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:50:37 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:36588 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfKSIuh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:50:37 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAA3f1_WrNNdKjzvAw--.369S2;
        Tue, 19 Nov 2019 16:50:30 +0800 (CST)
Subject: Re: [PATCH 0/9] wip-krbd-readonly
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Jason Dillaman <jdillama@redhat.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3ACD6.6040009@easystack.cn>
Date:   Tue, 19 Nov 2019 16:50:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAA3f1_WrNNdKjzvAw--.369S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRia9TUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiYBZyeli2lHUIegAAsD
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Hi Ilya,

On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> Hello,
>
> This series makes read-only mappings compatible with read-only caps:
> we no longer establish a watch,

Although this is true in userspace librbd, I think that's wired: when
there is someone is reading this image, it can be removed. And the
reader will get all zero for later reads.

What about register a watcher but always ack for notifications? Then
we can prevent removing from image being reading.

Ilya, Jason, what's your opinion?

Thanx
> acquire header and object map locks,
> etc.  In addition, because images mapped read-only can no longer be
> flipped to read-write, we allow read-only mappings with unsupported
> features, as long as the image is still readable.
>
> Thanks,
>
>                  Ilya
>
>
> Ilya Dryomov (9):
>    rbd: introduce rbd_is_snap()
>    rbd: introduce RBD_DEV_FLAG_READONLY
>    rbd: treat images mapped read-only seriously
>    rbd: disallow read-write partitions on images mapped read-only
>    rbd: don't acquire exclusive lock for read-only mappings
>    rbd: don't establish watch for read-only mappings
>    rbd: remove snapshot existence validation code
>    rbd: don't query snapshot features
>    rbd: ask for a weaker incompat mask for read-only mappings
>
>   drivers/block/rbd.c | 203 ++++++++++++++++++++------------------------
>   1 file changed, 93 insertions(+), 110 deletions(-)
>


