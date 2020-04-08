Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C621A1FBD
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 13:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgDHLWL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 07:22:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgDHLWL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Apr 2020 07:22:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BD58o189404;
        Wed, 8 Apr 2020 11:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kDsBGgrXF+k/Q5nP0fRg05GnVggXOtaY7NQZJwSYttc=;
 b=CLbq8FuEONaYgAs7NxAqNuNYvfzdSkeaeoR0S7k3id4ruHxIC7PyVYs904uXJ4QhI/0q
 GWd35WmleaA/hDJ+rcJNO0P3uzJQIzOmyKrgklTGZIauOIRTGJmC85DY348TSQJ6MC6I
 BN1SDHq0mzmS94Lde7h9kMhVd7qVB8jfUyg2SlNMNgt51UOYnPN0pJzoE5x9Ujk+RPrk
 4XKluh4EMEpKJIQvjLpymHl8iz24iUhL3xy9jsc2kDxUYAbi8T9wQpOD3O/1tSP/fmPt
 asLw8rjhdtmIHRt5yGfWlS3RV0TYxnhsm0xFgz5DSSau/7gfdDgZPOBoHJ8cX/4VscM7 jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 309ag398us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:22:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038BHMmm129571;
        Wed, 8 Apr 2020 11:22:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091m0re38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 11:22:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038BM7l8005229;
        Wed, 8 Apr 2020 11:22:08 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 04:22:07 -0700
Date:   Wed, 8 Apr 2020 14:22:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: attempt to do async create when possible
Message-ID: <20200408112201.GN2066@kadam>
References: <20200408111734.GA252918@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408111734.GA252918@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=710 phishscore=0 spamscore=0 adultscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=786 clxscore=1015
 priorityscore=1501 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080094
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 08, 2020 at 02:17:34PM +0300, Dan Carpenter wrote:
> Hello Jeff Layton,
> 
> The patch 9a8d03ca2e2c: "ceph: attempt to do async create when
> possible" from Nov 27, 2019, leads to the following static checker
> warning:
> 
> 	fs/ceph/file.c:540 ceph_async_create_cb()
> 	error: uninitialized symbol 'base'.

Sorry, see the unlink function as well.

    fs/ceph/dir.c:1072 ceph_async_unlink_cb()
    error: uninitialized symbol 'pathlen'.

regards,
dan carpenter

