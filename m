Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8537F30C18A
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhBBO0l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 09:26:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47046 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhBBOW0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 09:22:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112EJWVa141442;
        Tue, 2 Feb 2021 14:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zym7dCMbrQWtny8phtxzYDJHLtNzxPA2RobQi2pE6gk=;
 b=u9a6c0rjvJHP1TzqGUMatcQr7wLCMoC37iw2MKd7wAD5YH4cGba1iriFtZN8nu9EcdQB
 rkGW6ET2wSpWCxi7IVgwaNBrJUpW3A3OhRsnhh/ZFw3LfBVp4Ztz6Qv5QEGVIUm9ZKvG
 Ov4YicUMsyAWP4zxKfly1ibAJhT9+dbQ5lDUuDNXRhbfibqixxiqAMGUG0RPmYUPEUrO
 kPLbMh3YzXoipzIkG2KMePifcmULfzZiCTgbv97ES+2CN4JcBtU+Pq9+mEMJD1gLxBpU
 5ZkR6g5NvAOiXrae3GXS4o94vYWnf5LmJRuJM2LWhyqYPp7j+CxS4gmfNOIMUgXeMCvv eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyau5m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 14:20:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112EKW1a100431;
        Tue, 2 Feb 2021 14:20:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 36dhcwrdwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 14:20:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 112EKr2H019198;
        Tue, 2 Feb 2021 14:20:53 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 06:20:52 -0800
Date:   Tue, 2 Feb 2021 17:20:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: fix an oops in error handling in
 ceph_netfs_issue_op
Message-ID: <20210202142045.GD20820@kadam>
References: <20210202131041.43977-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202131041.43977-1-jlayton@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020098
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020098
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 02, 2021 at 08:10:41AM -0500, Jeff Layton wrote:
> Dan reported a potential oops in the cleanup if ceph_osdc_new_request
> returns an error. Eliminate the unneeded initialization of "req" and
> then just set it to NULL in the case where it holds an ERR_PTR.
> 
> Also, drop the unneeded NULL check before calling
> ceph_osdc_put_request.
> 
> Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Suggested-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>


Looks good.

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

