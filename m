Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB29C40C7C6
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Sep 2021 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhIOO7m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Sep 2021 10:59:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33414 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232242AbhIOO7l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 10:59:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18FEUr3n028559;
        Wed, 15 Sep 2021 10:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XZCB86uPKuV/GzpbaX8+VV3hy7G2w+54Yd25UoQjYiA=;
 b=p0hUCf/0qQPWDba9bizX/010a1RbKLZmp7dMoG7zsai0bIliEwc+zkgdLGOeV/5721JT
 tZjWfCp0cgVzr2CxY9Ca3vzq6tDiuo2x9/gRQ/N+Jg625dNmKwXzhX+2em0gf3S0nRvi
 /rkG2qsBFbyuYlCPWyWa1VMAgVFh6PaSPQik1D0qiS4sxkVECz/9gDB53mgW/5CdRPF7
 GfBEiuvdp/zKvNOzQngxOvA1HH7h5EYwZE8ya7sYmaHzzPGqA12GJJBncZlSF+YzftOS
 oyEoHdjXsJlbB9SWqwmnh3FYwYAqXnkU3wOw69hIcMZk3JWdcq9GGHDQO1T9iBOaiuqv kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b3jnc8t77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:57:56 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18FEVhPI002814;
        Wed, 15 Sep 2021 10:57:55 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b3jnc8t6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:57:55 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18FEqw1j024866;
        Wed, 15 Sep 2021 14:57:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3b0m3a72ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 14:57:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18FEvnm248824578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 14:57:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA8ECA405C;
        Wed, 15 Sep 2021 14:57:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0BD8A4054;
        Wed, 15 Sep 2021 14:57:48 +0000 (GMT)
Received: from [9.145.14.74] (unknown [9.145.14.74])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 14:57:48 +0000 (GMT)
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support for
 add_disk()
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-7-mcgrof@kernel.org>
 <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
 <f24da7d5-0b67-fa24-862f-0b27a2ab502c@linux.ibm.com>
 <YT+Bmvv3yXbuBddi@bombadil.infradead.org>
From:   =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
Message-ID: <417cf368-6821-442b-0a14-006b27690591@linux.ibm.com>
Date:   Wed, 15 Sep 2021 16:57:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YT+Bmvv3yXbuBddi@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9TnzlmD7Tr-lHTTUHflItAjPnDnMN64G
X-Proofpoint-GUID: ehalCfQDBnMyMC6p5nCgsPYP3FossWSO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150090
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 13/09/2021 18:51, Luis Chamberlain wrote:
> On Mon, Sep 13, 2021 at 02:19:38PM +0200, Jan Höppner wrote:
>> On 13/09/2021 10:17, Jan Höppner wrote:
>>> On 02/09/2021 19:41, Luis Chamberlain wrote:
>>>> We never checked for errors on add_disk() as this function
>>>> returned void. Now that this is fixed, use the shiny new
>>>> error handling.
>>>>
>>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>>> ---
>>>>  drivers/s390/block/dasd_genhd.c | 8 ++++++--
>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
>>>> index fa966e0db6ca..ba07022283bc 100644
>>>> --- a/drivers/s390/block/dasd_genhd.c
>>>> +++ b/drivers/s390/block/dasd_genhd.c
>>>> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>>>  {
>>>>  	struct gendisk *gdp;
>>>>  	struct dasd_device *base;
>>>> -	int len;
>>>> +	int len, rc;
>>>>  
>>>>  	/* Make sure the minor for this device exists. */
>>>>  	base = block->base;
>>>> @@ -79,7 +79,11 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>>>  	dasd_add_link_to_gendisk(gdp, base);
>>>>  	block->gdp = gdp;
>>>>  	set_capacity(block->gdp, 0);
>>>> -	device_add_disk(&base->cdev->dev, block->gdp, NULL);
>>>> +
>>>> +	rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
>>>> +	if (rc)
>>>> +		return rc;
>>>> +
>>>
>>> I think, just like with some of the other changes, there is some
>>> cleanup required before returning. I'll prepare a patch and
>>> come back to you.
>>>
>>
>> It's actually just one call that is required. The patch should
>> look like this:
>>
>> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
>> index fa966e0db6ca..80673dbfb1f9 100644
>> --- a/drivers/s390/block/dasd_genhd.c
>> +++ b/drivers/s390/block/dasd_genhd.c
>> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>  {
>>         struct gendisk *gdp;
>>         struct dasd_device *base;
>> -       int len;
>> +       int len, rc;
>>  
>>         /* Make sure the minor for this device exists. */
>>         base = block->base;
>> @@ -79,7 +79,13 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>         dasd_add_link_to_gendisk(gdp, base);
>>         block->gdp = gdp;
>>         set_capacity(block->gdp, 0);
>> -       device_add_disk(&base->cdev->dev, block->gdp, NULL);
>> +
>> +       rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
>> +       if (rc) {
>> +               dasd_gendisk_free(block);
>> +               return rc;
>> +       }
>> +
> 
> Thanks!
> 
> Would you like to to fold this fix into my patch and resend eventually?
> Or will you send a replacement?
> 
>   Luis
> 

I'd be fine with you just taking the changes for your patchset.
Once you've resent the whole patchset I'll review it and send
the usual ack or r-b.

regards,
Jan
