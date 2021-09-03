Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF7C4000FE
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349049AbhICOHw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 10:07:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235668AbhICOHv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 10:07:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183E3UbD181380;
        Fri, 3 Sep 2021 10:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=c5dtoeuWVsQu+Kx8qJUPUNaZorSC3QCCcGga7tN4sMM=;
 b=ScX/mNrpjpVGSx7jnWReoQPFcq12svD7XPCLBc9+6TcavrCpFAUGPoIUBGeID0O3nUQ8
 aG2XqrMHeI1H6uH7Bz5TxvciGjxAU+sdozMlFUgeWFBXfLNgYtqng2x7evKyHE7CSCmn
 4qvRCZDSoMunMRURUbVVrLC0nPgqByu2VIOhDqKf/0qKkrztBc3ddgbIuEFNRIYG3qlI
 4OxZa+v6kbClDzirNILXgdEG0wTxsWg+s0bg0AmFLE/P/U/FtTlcIfoeB2MszbyFM8Eb
 O6/4oYtU414B8YjaaKASZa+PwGVaLZEnJi4SjdP/5bMcv31V3PkLxnO5DfFZJ3o954ME 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aujf14aj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:06:25 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183E58pp001197;
        Fri, 3 Sep 2021 10:06:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aujf14agu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:06:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183DwGLW004761;
        Fri, 3 Sep 2021 14:06:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3au6q7h8bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 14:06:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183E2Ese61866466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 14:02:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA6AA52050;
        Fri,  3 Sep 2021 14:06:17 +0000 (GMT)
Received: from osiris (unknown [9.145.159.114])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CFE815206B;
        Fri,  3 Sep 2021 14:06:16 +0000 (GMT)
Date:   Fri, 3 Sep 2021 16:06:15 +0200
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] s390/block/xpram: add error handling support for
 add_disk()
Message-ID: <YTIr1w/qPvgioUfL@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-10-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902174105.2418771-10-mcgrof@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cnjpHgTUs8-WIbHVAJtbBq5h0cPzkyvT
X-Proofpoint-GUID: XAog2zEDSgH4nXCPv9bkGtJovoNDgwBR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_05:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 clxscore=1011 suspectscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030088
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 02, 2021 at 10:41:05AM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/s390/block/xpram.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
> index ce98fab4d43c..ed3904b6a9c8 100644
> --- a/drivers/s390/block/xpram.c
> +++ b/drivers/s390/block/xpram.c
> @@ -371,7 +371,9 @@ static int __init xpram_setup_blkdev(void)
>  		disk->private_data = &xpram_devices[i];
>  		sprintf(disk->disk_name, "slram%d", i);
>  		set_capacity(disk, xpram_sizes[i] << 1);
> -		add_disk(disk);
> +		rc = add_disk(disk);
> +		if (rc)
> +			goto out;

Hmm, this is a more or less dead device driver, and I'm wondering if
we shouldn't remove it instead. But anyway, your patch is not correct:

- del_gendisk for all registered disks has to be called
- unregister_blkdev(XPRAM_MAJOR, XPRAM_NAME) is missing as well

That would be more or or less xpram_exit with parameter.

You can send a new patch or I can provide a proper one, whatever you
prefer.
