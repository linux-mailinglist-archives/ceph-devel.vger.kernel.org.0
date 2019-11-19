Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567E41023F6
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 13:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKSMLo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 07:11:44 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:39850 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSMLn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 07:11:43 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACnoWb429Ndkp_wAw--.1121S2;
        Tue, 19 Nov 2019 20:11:36 +0800 (CST)
Subject: Re: [PATCH 0/9] wip-krbd-readonly
To:     Ilya Dryomov <idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
 <5DD3ACD6.6040009@easystack.cn>
 <CAOi1vP8xERUXtoh7sGUZDR6kRMKBVYx_6uofzA855OPR3Ar61A@mail.gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jason Dillaman <jdillama@redhat.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3DBF8.2010805@easystack.cn>
Date:   Tue, 19 Nov 2019 20:11:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8xERUXtoh7sGUZDR6kRMKBVYx_6uofzA855OPR3Ar61A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACnoWb429Ndkp_wAw--.1121S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4iQeYNDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiYBhyeli2lHXVegAAsQ
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/19/2019 07:59 PM, Ilya Dryomov wrote:
> On Tue, Nov 19, 2019 at 9:50 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>> Hi Ilya,
>>
>> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
>>> Hello,
>>>
>>> This series makes read-only mappings compatible with read-only caps:
>>> we no longer establish a watch,
>> Although this is true in userspace librbd, I think that's wired: when
>> there is someone is reading this image, it can be removed. And the
>> reader will get all zero for later reads.
>>
>> What about register a watcher but always ack for notifications? Then
>> we can prevent removing from image being reading.
> We can't register a watch because it is a write operation on the OSD
> and we want read-only mappings to be usable with read-only OSD caps:
>
>    $ ceph auth add client.ro ... osd 'profile rbd-read-only'
>    $ sudo rbd map --user ro -o ro ..
>
> Further, while returning zeros if an image or a snapshot is removed is
> bad, a watch isn't a good solution.  It can be lost, and even when it's
> there it's still racy.  See the description of patch 7


Right, it's not that easy. Maybe we need another series patches to 
improve it.
I am okey for it now, librbd is working in the same way.

Thanx
>
> Thanks,
>
>                  Ilya
>


