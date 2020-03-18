Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA901893B0
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 02:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgCRBd1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 21:33:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21732 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbgCRBd1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 21:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584495203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qg/nAeLqkx7fS36TSpxFr1fkq9YZJfsW4qw/oOHpxsE=;
        b=PHWkFKsTWqSRRUm4NkyRX+BHdgFtzx4nFda9YGsDm7tciR+WUp46OEvuWY4cUaivdd1UxC
        z765hScexGVONuSZY9QoON6ZsEMapt+3wLtRdbkyyh6aBlPrNOXCuFcxJhMwqCZq75TEiN
        h1VuqKPB0yBrNChIl3Lqh+szmZfc0sc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-TnLmpZ8bMP2aj5oIIawogA-1; Tue, 17 Mar 2020 21:33:20 -0400
X-MC-Unique: TnLmpZ8bMP2aj5oIIawogA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC546107ACC7;
        Wed, 18 Mar 2020 01:33:18 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 764535C1BB;
        Wed, 18 Mar 2020 01:33:16 +0000 (UTC)
Subject: Re: [ceph-client:testing 49/53] fs/ceph/debugfs.c:140: undefined
 reference to `__divdi3'
To:     Jeff Layton <jlayton@kernel.org>, kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
References: <202003180447.JrVfA6N9%lkp@intel.com>
 <7041ef971bd2c7fdb560f933d736ae6755dd1d9b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2cccffda-512c-d7cd-4d95-7cd8539a2119@redhat.com>
Date:   Wed, 18 Mar 2020 09:33:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7041ef971bd2c7fdb560f933d736ae6755dd1d9b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/18 5:09, Jeff Layton wrote:
> On Wed, 2020-03-18 at 04:35 +0800, kbuild test robot wrote:
>> tree:   https://github.com/ceph/ceph-client.git testing
>> head:   3188fc411f0c286ac4dc4ea146ddc4bf4f348b39
>> commit: dc1961a859fe49cad7a26001bd3e9a53f234bf59 [49/53] ceph: add global read latency metric support
>> config: i386-randconfig-e002-20200317 (attached as .config)
>> compiler: gcc-7 (Debian 7.5.0-5) 7.5.0
>> reproduce:
>>          git checkout dc1961a859fe49cad7a26001bd3e9a53f234bf59
>>          # save the attached .config to linux build tree
>>          make ARCH=i386
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     ld: fs/ceph/debugfs.o: in function `metric_show':
>>>> fs/ceph/debugfs.c:140: undefined reference to `__divdi3'
>> vim +140 fs/ceph/debugfs.c
>>
>>     126	
>>     127	static int metric_show(struct seq_file *s, void *p)
>>     128	{
>>     129		struct ceph_fs_client *fsc = s->private;
>>     130		struct ceph_mds_client *mdsc = fsc->mdsc;
>>     131		int i, nr_caps = 0;
>>     132		s64 total, sum, avg = 0;
>>     133	
>>     134		seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
>>     135		seq_printf(s, "-----------------------------------------------------\n");
>>     136	
>>     137		total = percpu_counter_sum(&mdsc->metric.total_reads);
>>     138		sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
>>     139		sum = jiffies_to_usecs(sum);
>>   > 140		avg = total ? sum / total : 0;
> Thanks kbuild bot!
>
> Old 32-bit arches can't do division on long long (64-bit) values. The
> right fix for this is probably to use do_div(sum, total), instead of
> trying to do this with normal integer division.
>
There is one div64_s64(), which should be we need here.

