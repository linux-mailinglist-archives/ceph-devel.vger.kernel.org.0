Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7E1146FAD
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2020 18:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAWR3k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jan 2020 12:29:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgAWR3k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jan 2020 12:29:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NHSpOY071992;
        Thu, 23 Jan 2020 17:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=wfZlMFocark5FAeY3R/kJhQdX+ZWRt39Y9Ybg1xOT2I=;
 b=M5VPg2kxgdWCP2f4oRi+3hPA8B/X2I9ZrXmRcU1LMJPxQfKDAEh0U6Jg9eTFQulImYQ0
 fjNMNSvjjTlw5Xa6ZD3H+5E2WFkwbDzqBNUukzIW9w+PK+GdPzEj1vpVD0txgs3hR8vs
 gs0HHPNvrdIh8MzFTh51ZUo2O0YxtidmscC9l/sboGX3Mjn4yVyik7utB/aW9z2Nq4nR
 +vJOI6mlT+/TRXRT6zQRNfIcDA+4If8gthuffgNNSqR6XwkTAenrUIiAHPqLRRFw/lpG
 dVSmHWl/FMdY0olagZvKq+0hd+6U0Pb7BgIFiC5vwhiUOMZgtkdyxwSLbIegTQRSC/yn Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrkq95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 17:29:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NHTK85173976;
        Thu, 23 Jan 2020 17:29:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xpq7n7v07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 17:29:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00NHTaaD002161;
        Thu, 23 Jan 2020 17:29:36 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 09:29:35 -0800
Date:   Thu, 23 Jan 2020 20:29:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: perform asynchronous unlink if we have
 sufficient caps
Message-ID: <20200123172927.GD1870@kadam>
References: <20200123153031.o53tzem7bhedyubg@kili.mountain>
 <7ccd37a37f2f700bc648cafcd87784e85c784a31.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ccd37a37f2f700bc648cafcd87784e85c784a31.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=651
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=715 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230137
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 10:45:31AM -0500, Jeff Layton wrote:
> On Thu, 2020-01-23 at 18:30 +0300, Dan Carpenter wrote:
> > Hello Jeff Layton,
> > 
> > The patch d6566c62c529: "ceph: perform asynchronous unlink if we have
> > sufficient caps" from Apr 2, 2019, leads to the following static
> > checker warning:
> > 
> > 	fs/ceph/dir.c:1059 get_caps_for_async_unlink()
> > 	error: uninitialized symbol 'got'.
> > 
> > fs/ceph/dir.c
> >   1051  static bool get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
> >   1052  {
> >   1053          struct ceph_inode_info *ci = ceph_inode(dir);
> >   1054          struct ceph_dentry_info *di;
> >   1055          int ret, want, got;
> >   1056  
> >   1057          want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
> >   1058          ret = ceph_try_get_caps(dir, 0, want, true, &got);
> >   1059          dout("Fx on %p ret=%d got=%d\n", dir, ret, got);
> >                                                            ^^^
> > Uninitialized on error.
> > 
> >   1060          if (ret != 1 || got != want)
> >   1061                  return false;
> >   1062  
> >   1063          spin_lock(&dentry->d_lock);
> >   1064          di = ceph_dentry(dentry);
> > 
> 
> Hi Dan,
> 
> This looks like a false positive to me?
> 
> On error, ret != 1, and got shouldn't matter in that case. If
> ceph_try_get_caps does return 1 then "got" will be filled out.


It's complaining about the printk before the error handling.

regards,
dan carpenter

