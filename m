Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6F31BD15E
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Apr 2020 02:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD2Aqr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Apr 2020 20:46:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51008 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726274AbgD2Aqq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 20:46:46 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7BAC97760B1CF50C5999;
        Wed, 29 Apr 2020 08:46:43 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.100) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 08:46:33 +0800
Subject: Re: [PATCH V2] fs/ceph:fix double unlock in handle_cap_export()
To:     Jeff Layton <jlayton@kernel.org>, <sage@redhat.com>,
        <idryomov@gmail.com>
CC:     <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
References: <1588079622-423774-1-git-send-email-wubo40@huawei.com>
 <e89bd817c69422c85f1945041dd83fbe8d534805.camel@kernel.org>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <6c99072a-f92b-b7e8-9aef-509d1a9ee985@huawei.com>
Date:   Wed, 29 Apr 2020 08:46:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e89bd817c69422c85f1945041dd83fbe8d534805.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.100]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/4/28 22:48, Jeff Layton wrote:
> On Tue, 2020-04-28 at 21:13 +0800, Wu Bo wrote:
>> if the ceph_mdsc_open_export_target_session() return fails,
>> should add a lock to avoid twice unlocking.
>> Because the lock will be released at the retry or out_unlock tag.
>>
> 
> The problem looks real, but...
> 
>> --
>> v1 -> v2:
>> add spin_lock(&ci->i_ceph_lock) before goto out_unlock tag.
>>
>> Signed-off-by: Wu Bo <wubo40@huawei.com>
>> ---
>>   fs/ceph/caps.c | 27 +++++++++++++++------------
>>   1 file changed, 15 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 185db76..414c0e2 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3731,22 +3731,25 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>   
>>   	/* open target session */
>>   	tsession = ceph_mdsc_open_export_target_session(mdsc, target);
>> -	if (!IS_ERR(tsession)) {
>> -		if (mds > target) {
>> -			mutex_lock(&session->s_mutex);
>> -			mutex_lock_nested(&tsession->s_mutex,
>> -					  SINGLE_DEPTH_NESTING);
>> -		} else {
>> -			mutex_lock(&tsession->s_mutex);
>> -			mutex_lock_nested(&session->s_mutex,
>> -					  SINGLE_DEPTH_NESTING);
>> -		}
>> -		new_cap = ceph_get_cap(mdsc, NULL);
>> -	} else {
>> +	if (IS_ERR(tsession)) {
>>   		WARN_ON(1);
>>   		tsession = NULL;
>>   		target = -1;
>> +		mutex_lock(&session->s_mutex);
>> +		spin_lock(&ci->i_ceph_lock);
>> +		goto out_unlock;
> 
> Why did you make this case goto out_unlock instead of retrying as it did
> before?
> 

If the problem occurs, target = -1, and goto retry lable, you need to 
call __get_cap_for_mds() or even call __ceph_remove_cap(), and then jump 
to out_unlock lable. All I think is unnecessary, goto out_unlock instead 
of retrying directly.

Thanks.
Wu Bo

>> +	}
>> +
>> +	if (mds > target) {
>> +		mutex_lock(&session->s_mutex);
>> +		mutex_lock_nested(&tsession->s_mutex,
>> +					SINGLE_DEPTH_NESTING);
>> +	} else {
>> +		mutex_lock(&tsession->s_mutex);
>> +		mutex_lock_nested(&session->s_mutex,
>> +					SINGLE_DEPTH_NESTING);
>>   	}
>> +	new_cap = ceph_get_cap(mdsc, NULL);
>>   	goto retry;
>>   
>>   out_unlock:
> 


