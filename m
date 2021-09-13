Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA19408ADA
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhIMMRU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 08:17:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237090AbhIMMRT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:17:19 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18DBV4hl032581;
        Mon, 13 Sep 2021 08:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xlP+LwjYIwYnUxPeclWKOSgT6kSEuo++vPIF3XqB458=;
 b=rrcn7jniYYZy39eRPyK6ld2RF6RXYYjp3m+EZpc22eHesKoWk23L4BoKxA4SQksWcGYE
 Ar3unj5JZoMMsrGiYs1LKP1+NQuF8aJpFikukfssEF6yPnDdCGEysxjpOdeh7uZsTMZP
 z/h/aoohVEO6w+GHghbFPMV2nJhjxpxwhWzA48ChHYB9o3BIW0GY35sYCvfWpvR5AmdE
 8oyIwBHBPBPvqEI7LQ06K1ADfEp7RdWWXFVFrzo6D73mrc33lIuhIeYP7NYGWWSW+IQQ
 DLYOJwE6yyx8q1JuL9LVhJUBAEZDLt69tEOFR/zNkS9kEIG42K97UTkEAaR0L5IWh7vf 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b23hvvd79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:15:19 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18DBQ7Fb030676;
        Mon, 13 Sep 2021 08:15:18 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b23hvvd5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:15:17 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18DCE4d8002394;
        Mon, 13 Sep 2021 12:15:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b0m38yay8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 12:15:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18DCFB3s45351186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 12:15:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 636D711C0D5;
        Mon, 13 Sep 2021 12:15:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BFBA11C0B2;
        Mon, 13 Sep 2021 12:15:10 +0000 (GMT)
Received: from [9.145.51.25] (unknown [9.145.51.25])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Sep 2021 12:15:10 +0000 (GMT)
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support for
 add_disk()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
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
 <YT8O/NL2pEGUjYj9@infradead.org>
From:   =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
Message-ID: <93bfc4ce-62f1-e21c-5dca-82029b2fc388@linux.ibm.com>
Date:   Mon, 13 Sep 2021 14:15:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YT8O/NL2pEGUjYj9@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i1DhJLKl-4vLh41BXihH3RVurh7Dcq6N
X-Proofpoint-GUID: CgRXnBXQrEZYnagyiSXSmcuMePxFid_y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130048
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 13/09/2021 10:42, Christoph Hellwig wrote:
> On Mon, Sep 13, 2021 at 10:17:48AM +0200, Jan H??ppner wrote:
>> I think, just like with some of the other changes, there is some
>> cleanup required before returning. I'll prepare a patch and
>> come back to you.
> 
> If you are touching the dasd probe path anyway, can you look insto
> switching to use blk_mq_alloc_disk as well?  Right now dasd allocates
> the request_queue and gendisk separately in different stages of
> initialization, but unlike SCSI which needs to probe using just the
> request_queue I can't find a good reason for that.
> 

Thanks for the hint. We'll be working on it separately though, as
it seems to require a bit more effort from a first glance.
We'll send a separate patch (or patchset) soon.

regards,
Jan
