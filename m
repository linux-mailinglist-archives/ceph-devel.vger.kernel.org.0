Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17175408654
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 10:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbhIMITl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 04:19:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237966AbhIMITk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 04:19:40 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18D7H3eH032230;
        Mon, 13 Sep 2021 04:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/QzFF3fZPcOazDgK94YUNtDPRVXwWmwYXrgzAl0cjS8=;
 b=LZ1IatJS4Vf8fkMOpw3nPsnMsWvXi1zKOHNtdoJR3WA1JOBt6akxtAUeaFcmfSrgtfzv
 4NRm+1ZMgBCrY9RGl4dUX70gpcEuR/zoFChDQB/2NaF/00szr5Oq+z1uBI4QDWhfD6zc
 P4rPwNr4fozCqJ0RGb+LWgtoO6TFVqtlItWyJVzIn+2xzExDULNQ2sA1K5ofpZpOPT8T
 41lEG9BrbDHup3b+CuJPl0uLd2nP2dTMKAS/okY1PdF2CEfrb2UeKEaug1ngWcpv8R0f
 l5A1Tv0GjOGn+bmD16W5XhxbS2fbbACIEnfaoLzXVgrhfKN3kKq+UCiD6E2iiWjFNGh3 QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b19j7cd6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 04:17:57 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18D7xD27005324;
        Mon, 13 Sep 2021 04:17:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b19j7cd5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 04:17:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18D8DW0J022837;
        Mon, 13 Sep 2021 08:17:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3b0kqj52da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:17:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18D8HnQ554067622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 08:17:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75FA24C091;
        Mon, 13 Sep 2021 08:17:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AD8A4C0A0;
        Mon, 13 Sep 2021 08:17:48 +0000 (GMT)
Received: from [9.145.51.25] (unknown [9.145.51.25])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Sep 2021 08:17:48 +0000 (GMT)
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support for
 add_disk()
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
From:   =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
Message-ID: <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
Date:   Mon, 13 Sep 2021 10:17:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902174105.2418771-7-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iIf5PatQK3tLGbkyIENHhS0UWFy_EX4T
X-Proofpoint-GUID: iNtwPwv-S4pcIL1NuHAo4zaBrJP6dp5o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109120024
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 02/09/2021 19:41, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/s390/block/dasd_genhd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
> index fa966e0db6ca..ba07022283bc 100644
> --- a/drivers/s390/block/dasd_genhd.c
> +++ b/drivers/s390/block/dasd_genhd.c
> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>  {
>  	struct gendisk *gdp;
>  	struct dasd_device *base;
> -	int len;
> +	int len, rc;
>  
>  	/* Make sure the minor for this device exists. */
>  	base = block->base;
> @@ -79,7 +79,11 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>  	dasd_add_link_to_gendisk(gdp, base);
>  	block->gdp = gdp;
>  	set_capacity(block->gdp, 0);
> -	device_add_disk(&base->cdev->dev, block->gdp, NULL);
> +
> +	rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
> +	if (rc)
> +		return rc;
> +

I think, just like with some of the other changes, there is some
cleanup required before returning. I'll prepare a patch and
come back to you.

>  	return 0;
>  }
>  
> 

