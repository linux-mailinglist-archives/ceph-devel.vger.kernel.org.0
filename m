Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A709400109
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349183AbhICOKW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 10:10:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234108AbhICOKU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 10:10:20 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183E4Dqt045274;
        Fri, 3 Sep 2021 10:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=T8qKkacEAjls3JdMrwNoLe22cMzRDNeMuYrdEDMdqP8=;
 b=DkIabwNvwqy+OxJKJf55xcy4NMbljWWEkLkqQOSmwt/nhbgqanVH7qFN1S5f7/eW9mXe
 cVbTVYK3r/nCkH/nRjEhP69stV+20Cd+GzQ1AB+C7VrS+XASxCTRoNHBbZlXLGipS2WA
 U4qizChZb+XpyxGVSSWNf3Ic9rLloxlMkdZbunwBEmllP8vDPUDvdBId7iYX0rJsVUe1
 gJ+PmLWuIOaUHAgJPPJF0PVX/vyKqHkjYB4TaaTpvZvjaSfyViczyi2ABfMFGs1waaJP
 v+mYj+EUrhFU/8eh3Ov/7P5Ekg8Gx6fhQi/oqf/z4YUYrObfIniVKWNVd7nh2l1qQing HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aumn090tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:08:58 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183E51pJ048250;
        Fri, 3 Sep 2021 10:08:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aumn090ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:08:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183E8G53000659;
        Fri, 3 Sep 2021 14:08:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3au6q7h9bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 14:08:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183E8pcB56295814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 14:08:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C862A405C;
        Fri,  3 Sep 2021 14:08:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22B4AA406B;
        Fri,  3 Sep 2021 14:08:50 +0000 (GMT)
Received: from osiris (unknown [9.145.159.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Sep 2021 14:08:50 +0000 (GMT)
Date:   Fri, 3 Sep 2021 16:08:48 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH 7/9] s390/block/dcssblk: add error handling support for
 add_disk()
Message-ID: <YTIscKy+jg5L/TMh@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-8-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902174105.2418771-8-mcgrof@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: evTghnCKdw3wnpHWQfjb73FGFO4Flkw_
X-Proofpoint-ORIG-GUID: S1BIuadY5tzMuVpbTN3TLJm7CsQHP5RV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_05:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030088
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 02, 2021 at 10:41:03AM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/s390/block/dcssblk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 5be3d1c39a78..b0fd5009a12e 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>  	}
>  
>  	get_device(&dev_info->dev);
> -	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> +	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> +	if (rc)
> +		goto put_dev;

This looks not correct to me. We seem to have now in case of an error:

- reference count imbalance (= memory leak)
- dax cleanup is missing
