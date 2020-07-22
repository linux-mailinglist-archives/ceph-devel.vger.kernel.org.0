Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2969822988E
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 14:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732402AbgGVMuj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 08:50:39 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2987 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732393AbgGVMuh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 08:50:37 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 932BA15591EA1313251F;
        Wed, 22 Jul 2020 20:50:34 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 22 Jul 2020 20:50:34 +0800
Received: from [10.174.177.240] (10.174.177.240) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 22 Jul 2020 20:50:34 +0800
Subject: Re: [PATCH] fs:ceph: Remove unused variables in ceph_mdsmap_decode()
To:     Jeff Layton <jlayton@kernel.org>, <idryomov@gmail.com>
CC:     <ceph-devel@vger.kernel.org>
References: <20200720114017.24869-1-jiayang5@huawei.com>
 <028c75cdba6faf15ede3ef38937614694a0945d1.camel@kernel.org>
From:   Jia Yang <jiayang5@huawei.com>
Message-ID: <41f8bd4a-fcca-b142-35f4-a2af73c97c02@huawei.com>
Date:   Wed, 22 Jul 2020 20:50:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <028c75cdba6faf15ede3ef38937614694a0945d1.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.240]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme716-chm.china.huawei.com (10.1.199.112)
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks a lot!

On 2020/7/21 4:24, Jeff Layton wrote:
> On Mon, 2020-07-20 at 19:40 +0800, Jia Yang wrote:
>> Fix build warnings:
>>
>> fs/ceph/mdsmap.c: In function ‘ceph_mdsmap_decode’:
>> fs/ceph/mdsmap.c:192:7: warning:
>> variable ‘info_cv’ set but not used [-Wunused-but-set-variable]
>> fs/ceph/mdsmap.c:177:7: warning:
>> variable ‘state_seq’ set but not used [-Wunused-but-set-variable]
>> fs/ceph/mdsmap.c:123:15: warning:
>> variable ‘mdsmap_cv’ set but not used [-Wunused-but-set-variable]
>>
>> Signed-off-by: Jia Yang <jiayang5@huawei.com>
>> ---
>>  fs/ceph/mdsmap.c | 7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index 889627817e52..9496287f2071 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -120,7 +120,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>  	const void *start = *p;
>>  	int i, j, n;
>>  	int err;
>> -	u8 mdsmap_v, mdsmap_cv;
>> +	u8 mdsmap_v;
>>  	u16 mdsmap_ev;
>>  
>>  	m = kzalloc(sizeof(*m), GFP_NOFS);
>> @@ -129,7 +129,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>  
>>  	ceph_decode_need(p, end, 1 + 1, bad);
>>  	mdsmap_v = ceph_decode_8(p);
>> -	mdsmap_cv = ceph_decode_8(p);
> 
> These decode calls have the side effect of incrementing "p", so this
> will break decoding. You can still get rid of them, but you'll want to
> convert them to ceph_decode_skip_* calls.
> 
>>  	if (mdsmap_v >= 4) {
>>  	       u32 mdsmap_len;
>>  	       ceph_decode_32_safe(p, end, mdsmap_len, bad);
>> @@ -174,7 +173,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>  		u64 global_id;
>>  		u32 namelen;
>>  		s32 mds, inc, state;
>> -		u64 state_seq;
>>  		u8 info_v;
>>  		void *info_end = NULL;
>>  		struct ceph_entity_addr addr;
>> @@ -189,9 +187,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>  		info_v= ceph_decode_8(p);
>>  		if (info_v >= 4) {
>>  			u32 info_len;
>> -			u8 info_cv;
>>  			ceph_decode_need(p, end, 1 + sizeof(u32), bad);
>> -			info_cv = ceph_decode_8(p);
>>  			info_len = ceph_decode_32(p);
>>  			info_end = *p + info_len;
>>  			if (info_end > end)
>> @@ -210,7 +206,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>  		mds = ceph_decode_32(p);
>>  		inc = ceph_decode_32(p);
>>  		state = ceph_decode_32(p);
>> -		state_seq = ceph_decode_64(p);
>>  		err = ceph_decode_entity_addr(p, end, &addr);
>>  		if (err)
>>  			goto corrupt;
> 
