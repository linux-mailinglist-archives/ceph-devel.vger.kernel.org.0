Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203A82CCDBF
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Dec 2020 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgLCEHu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Dec 2020 23:07:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEHr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Dec 2020 23:07:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3457vJ020751;
        Thu, 3 Dec 2020 04:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Oww/8iFoOsE1zM3fFYoD3Oq4k1GA5uwflIdMRTl3mec=;
 b=fyla7Dqb2gXhO/cJjdl0yvSvOSu/pagItggvc1t2wSrUk/mP4xAnnh/0IhPPdR0aHoKe
 Ibni9NreZWk+zLuvcfCa9UZ9Td3PC0ZwRbDIBKx8hDDmtU9MxPotY8+daPljUXKy/0TM
 UaOQPNmirWNqgXI/lKF57lDeYMpkYIdC9w88WBiGgcCTHLSP4D3eZsEqh8M5orT9vFU+
 3J+CzrRyLqjh/Qe6oMbo3xP/R5oKlGlWp/1tjaNn3Ip0RGIGJw0oiZMFx543Fsil29AS
 pWLwKI7X8Uhs9ddrmZs4/E2NU7HFDKup2QFJ/eT8YkX9R/GtWlIEP+mjI/J6T8uSiuIw rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkuqqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 04:06:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B340D7O085693;
        Thu, 3 Dec 2020 04:04:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f19ag8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 04:04:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B344aX8004987;
        Thu, 3 Dec 2020 04:04:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 20:04:36 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/4] block: add a hard-readonly flag to struct gendisk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dpza6nz.fsf@ca-mkp.ca.oracle.com>
References: <20201129181926.897775-1-hch@lst.de>
        <20201129181926.897775-2-hch@lst.de>
Date:   Wed, 02 Dec 2020 23:04:33 -0500
In-Reply-To: <20201129181926.897775-2-hch@lst.de> (Christoph Hellwig's message
        of "Sun, 29 Nov 2020 19:19:23 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030022
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Hi Christoph!

>  - If BLKROSET is used to set a whole-disk device read-only, any
>    partitions will end up in a read-only state until the user
>    explicitly clears the flag.

This no longer appears to be the case with your tweak.

It's very common for database folks to twiddle the read-only state of
block devices and partitions. I know that our users will find it very
counter-intuitive that setting /dev/sda read-only won't prevent writes
to /dev/sda1.

>  int bdev_read_only(struct block_device *bdev)
>  {
>  	if (!bdev)
>  		return 0;
> -	return bdev->bd_read_only;
> +	return bdev->bd_read_only ||
> +		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
>  }

I suggest doing bd->bd_read_only || get_disk_ro(...) here. That does
take part0 into account.

>  static inline int get_disk_ro(struct gendisk *disk)
>  {
> -	return disk->part0->bd_read_only;
> +	return disk->part0->bd_read_only ||
> +		test_bit(GD_READ_ONLY, &disk->state);
>  }
>  
>  extern void disk_block_events(struct gendisk *disk);

-- 
Martin K. Petersen	Oracle Linux Engineering
