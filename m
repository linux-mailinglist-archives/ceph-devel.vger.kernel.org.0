Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192AD2CD86D
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Dec 2020 15:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgLCOCy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Dec 2020 09:02:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40236 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgLCOCy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Dec 2020 09:02:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3DxZxx020238;
        Thu, 3 Dec 2020 14:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=08xcOXb4h+rrVxGTGyogS4/r+kWmWA3YCYglvjMxUYE=;
 b=kcyvep2IlMZNXZgX98SJMwlq2lXuIIyhI9HBQx9Ss/Quz4W3V/oL3EPzB0qtUwEQPF29
 nIOd7EiId5TTO9+alNySyHgepPuhwgCBDOev+s7nuJufTNAS++ChtlvyMyabXxruCmRJ
 RONOBtRl1a9ac4CgvYSyr/LHBmb/huDm+Rx6YcRDMnx9+PpiEMWxopcjK7X/D7riX2r9
 kyZuuWQRQOMrH54UyV/hy2dVUQXubhv14hhjrWeD8+iXSVguxLtRepgAyNkMAuenLf0T
 IC61q43W1VjqWKQ2b++VvaSFHC2T9i7PnUgQAPp+0dp+IgbIngu4OQE5wEI5V2aP9xoT wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqx45h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 14:01:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3E0Ixr099297;
        Thu, 3 Dec 2020 14:01:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540f1vcx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 14:01:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3E1gNM026727;
        Thu, 3 Dec 2020 14:01:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 06:01:42 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <yq1zh2v826s.fsf@ca-mkp.ca.oracle.com>
References: <20201129181926.897775-1-hch@lst.de>
        <20201129181926.897775-2-hch@lst.de>
        <yq17dpza6nz.fsf@ca-mkp.ca.oracle.com> <20201203085339.GA17110@lst.de>
Date:   Thu, 03 Dec 2020 09:01:39 -0500
In-Reply-To: <20201203085339.GA17110@lst.de> (Christoph Hellwig's message of
        "Thu, 3 Dec 2020 09:53:39 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030085
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Christoph,

>> It's very common for database folks to twiddle the read-only state of
>> block devices and partitions. I know that our users will find it very
>> counter-intuitive that setting /dev/sda read-only won't prevent
>> writes to /dev/sda1.
>
> What I'm worried about it is that this would be a huge change from the
> historic behavior.

But that's what my users complained about and what the patch tried to
address.

Also, the existing behavior is inconsistent in the sense that doing:

# blockdev --setro /dev/sda
# echo foo > /dev/sda1

permits writes. But:

# blockdev --setro /dev/sda
<something triggers revalidate>
# echo foo > /dev/sda1

doesn't.

And a subsequent:

# blockdev --setrw /dev/sda
# echo foo > /dev/sda1

doesn't work either since sda1's read-only policy has been inherited
from the whole-disk device.

You need to do:

# blockdev --rereadpt

after setting the whole-disk device rw to effectuate the same change on
the partitions, otherwise they are stuck being read-only indefinitely.

However, setting the read-only policy on a partition does *not* require
the revalidate step. As a matter of fact, doing the revalidate will blow
away the policy setting you just made.

So the user needs to take different actions depending on whether they
are trying to read-protect a whole-disk device or a partition. Despite
using the same ioctl. That is really confusing.

The intent of my patch was to ensure that:

 - Hardware-initiated read-only state changes would not alter the user's
   whole-disk or partition policy settings.

 - Setting a policy on the whole-disk device would prevent writes to the
   whole device as the user clearly intended.

I have lost count how many times our customers have had data clobbered
because of ambiguity of the existing whole-disk device policy. The
current behavior violates the principle of least surprise by letting the
user think they write protected the whole disk when they actually
didn't.

-- 
Martin K. Petersen	Oracle Linux Engineering
