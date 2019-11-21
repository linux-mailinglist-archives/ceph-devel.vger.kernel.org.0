Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB535105CD5
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 23:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUWs2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 17:48:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbfKUWs2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 17:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574376507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bH5l0gSBq3QEv1PdR5x7jR1zif+0G6x7B0u2uAYKx4=;
        b=Sor5i69gz0io2rKMNNXLnUiD5V/cyKH9TPwBFVl3abD3t077GaOC98dh+2pJu059YSH+pb
        2z1RA12+75JrhA2SC7nhMPSr/p32sGe3emXq31WZsdpyO65g8vvWtfJDvbhTnLPjwqO7fU
        iyTbwtL85z82diWjQsJaVh12Kw434QU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-CVn5aZoeOXS6aWg6dE2tYw-1; Thu, 21 Nov 2019 17:48:24 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3408024F2;
        Thu, 21 Nov 2019 22:48:23 +0000 (UTC)
Received: from [10.3.116.166] (ovpn-116-166.phx2.redhat.com [10.3.116.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97CB010372C1;
        Thu, 21 Nov 2019 22:48:22 +0000 (UTC)
Subject: Re: device class : nvme
From:   Mark Nelson <mnelson@redhat.com>
To:     Sage Weil <sage@newdream.net>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>
Cc:     dev@ceph.io, ceph-devel@vger.kernel.org
References: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
 <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
 <b11c2c0a-5d0e-0d63-5a46-d7b8d8bbd413@redhat.com>
Message-ID: <51ad1b37-bf6b-50ad-d06d-7db0d9d1ad45@redhat.com>
Date:   Thu, 21 Nov 2019 16:48:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b11c2c0a-5d0e-0d63-5a46-d7b8d8bbd413@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: CVn5aZoeOXS6aWg6dE2tYw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/21/19 4:46 PM, Mark Nelson wrote:
> On 11/21/19 4:25 PM, Sage Weil wrote:
>> Adding dev@ceph.io
>>
>> On Thu, 21 Nov 2019, Muhammad Ahmad wrote:
>>> While trying to research how crush maps are used/modified I stumbled
>>> upon these device classes.
>>> https://ceph.io/community/new-luminous-crush-device-classes/
>>>
>>> I wanted to highlight that having nvme as a separate class will
>>> eventually break and should be removed.
>>>
>>> There is already a push within the industry to consolidate future
>>> command sets and NVMe will likely be it. In other words, NVMe HDDs are
>>> not too far off. In fact, the recent October OCP F2F discussed this
>>> topic in detail.
>>>
>>> If the classification is based on performance then command set
>>> (SATA/SAS/NVMe) is probably not the right classification.
>> I opened a PR that does this:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0https://github.com/ceph/ceph/pull/31796
>>
>> I can't remember seeing 'nvme' as a device class on any real cluster;=20
>> the
>> exceptoin is my basement one, and I think the only reason it ended up=20
>> that
>> way was because I deployed bluestore *very* early on (with ceph-disk)=20
>> and
>> the is_nvme() detection helper doesn't work with LVM.=C2=A0 That's my=20
>> theory at
>> least.. can anybody with bluestore on NVMe devices confirm? Does anybody
>> see class 'nvme' devices in their cluster?
>>
>> Thanks!
>> sage
>>
>
> Here's what we've got on the new performance nodes with Intel NVMe=20
> drives:
>
>
> ID=C2=A0 CLASS WEIGHT=C2=A0=C2=A0 TYPE NAME
> =C2=A0-1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 64.00000 root default
> =C2=A0-3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 64.00000=C2=A0=C2=A0=C2=A0=
=C2=A0 rack localrack
> =C2=A0-2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8.00000=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 host o03
> =C2=A0 0=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.0
> =C2=A0 1=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.1
> =C2=A0 2=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.2
> =C2=A0 3=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.3
> =C2=A0 4=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.4
> =C2=A0 5=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.5
> =C2=A0 6=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.6
> =C2=A0 7=C2=A0=C2=A0 ssd=C2=A0 1.00000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 osd.7
>
>
> Mark
>

I should probably clarify that this cluster was built with cbt though!


Mark

