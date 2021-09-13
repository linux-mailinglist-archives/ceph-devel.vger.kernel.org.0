Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A2E408AED
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 14:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhIMMV2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 08:21:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239866AbhIMMV0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:21:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18D9wYg1008000;
        Mon, 13 Sep 2021 08:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1hIWw/wSnWofckL41D1XzUL6GWvmJ86ckis+en3IDQU=;
 b=FHD/9GFP4oMbQvwproBcX0w8FAoZ9aiZgfpupLm0PK3rBr+RePrUKsh+LqZj6UgRwwp6
 Zfh9I24AzRQ3Ke5wqXH+fxQG5HT/HPz1BsbQZ9fQe84WuNT/JQQgpzbY3o70zHtmB/uc
 ic6Vo9Gb7CwEkRnPwhUnWkWfZ8t8xccLcQA3eFhgMbmZh7nF5iAl5VWNTXxJPMm6N+yF
 ZE6uTalYW3ts0xPcTE2BGKkSIaNwnTcorfAh7wVWl8yoaFq5bb+WPDBZ3uZjvr7XD7O2
 YU+0UQI6qwk5RoZzXj0INp85Xq3xbeCa/ryD5oyHkgi6zFYKlG/jj7cKJcHflQOG0ZWs QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b24fvawne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:19:46 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18DBRbiC022017;
        Mon, 13 Sep 2021 08:19:45 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b24fvawmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:19:45 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18DCE8S7029062;
        Mon, 13 Sep 2021 12:19:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3b0m38qc81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 12:19:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18DCJdGv42729806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 12:19:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9882911C050;
        Mon, 13 Sep 2021 12:19:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D3D811C069;
        Mon, 13 Sep 2021 12:19:38 +0000 (GMT)
Received: from [9.145.51.25] (unknown [9.145.51.25])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Sep 2021 12:19:38 +0000 (GMT)
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support for
 add_disk()
From:   =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org
Cc:     linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-7-mcgrof@kernel.org>
 <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
Message-ID: <f24da7d5-0b67-fa24-862f-0b27a2ab502c@linux.ibm.com>
Date:   Mon, 13 Sep 2021 14:19:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gi0m7LOuzf2vMdtL1hb1AAbX0QKyIfvS
X-Proofpoint-ORIG-GUID: dBdYHCxX_EYkPQrzsDHcfwD3gZgwOseq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130063
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 13/09/2021 10:17, Jan Höppner wrote:
> On 02/09/2021 19:41, Luis Chamberlain wrote:
>> We never checked for errors on add_disk() as this function
>> returned void. Now that this is fixed, use the shiny new
>> error handling.
>>
>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>> ---
>>  drivers/s390/block/dasd_genhd.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
>> index fa966e0db6ca..ba07022283bc 100644
>> --- a/drivers/s390/block/dasd_genhd.c
>> +++ b/drivers/s390/block/dasd_genhd.c
>> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>  {
>>  	struct gendisk *gdp;
>>  	struct dasd_device *base;
>> -	int len;
>> +	int len, rc;
>>  
>>  	/* Make sure the minor for this device exists. */
>>  	base = block->base;
>> @@ -79,7 +79,11 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>>  	dasd_add_link_to_gendisk(gdp, base);
>>  	block->gdp = gdp;
>>  	set_capacity(block->gdp, 0);
>> -	device_add_disk(&base->cdev->dev, block->gdp, NULL);
>> +
>> +	rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
>> +	if (rc)
>> +		return rc;
>> +
> 
> I think, just like with some of the other changes, there is some
> cleanup required before returning. I'll prepare a patch and
> come back to you.
> 

It's actually just one call that is required. The patch should
look like this:

diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index fa966e0db6ca..80673dbfb1f9 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 {
        struct gendisk *gdp;
        struct dasd_device *base;
-       int len;
+       int len, rc;
 
        /* Make sure the minor for this device exists. */
        base = block->base;
@@ -79,7 +79,13 @@ int dasd_gendisk_alloc(struct dasd_block *block)
        dasd_add_link_to_gendisk(gdp, base);
        block->gdp = gdp;
        set_capacity(block->gdp, 0);
-       device_add_disk(&base->cdev->dev, block->gdp, NULL);
+
+       rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
+       if (rc) {
+               dasd_gendisk_free(block);
+               return rc;
+       }
+
        return 0;
 }

regards,
Jan
