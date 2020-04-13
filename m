Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84201A6CA9
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Apr 2020 21:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbgDMTmM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Apr 2020 15:42:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbgDMTmL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Apr 2020 15:42:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DJeCTt069973;
        Mon, 13 Apr 2020 19:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Ep8ZtkjsJRhmiQiuObNMaeUjImg3Vm8P1Dm6oNvQS08=;
 b=FpYnSFmUA6u8UeZGY3A4uhRK1ozkdCwSUBBaxvY907BZXp+ZKtX0zLpwKdjuA6aCn2y6
 ATIpfJr4WmdsT/yRGq3+TJ8vXYSM7m3DqtBPyI/HiDX5insH1XQKSNkRgCgxcwJl8iSt
 cyhNSaRxjS0LBukV7E6oDMXGoZiVDd/ws+vmhuSm+pi1Yy5FgRN7VZYOQcUkHqMAnEVF
 AAwYjTBeUKEE6YZAxCmcwKJBM3ShPUrCbNBvoqSGiwSG25HdRi+zUJkTdqy0WDKR8nAL
 6Z3Hsxymx9PHa97xoKctUb8auvO8fJXKif4fHXASVCVIKxySTSuVzx7ZJjXzGiwtXzzF FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30b5um0ht6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 19:42:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DJboUf091138;
        Mon, 13 Apr 2020 19:42:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30bqcf303h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 19:42:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DJg0cU006273;
        Mon, 13 Apr 2020 19:42:00 GMT
Received: from kadam (/10.175.164.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 12:41:59 -0700
Date:   Mon, 13 Apr 2020 22:41:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
Message-ID: <20200413194153.GD14511@kadam>
References: <20200408142125.52908-1-jlayton@kernel.org>
 <20200408142125.52908-2-jlayton@kernel.org>
 <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
 <ded1b71dcda70e3a249df21c294607dac6545694.camel@kernel.org>
 <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com>
 <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=947
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=2 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130146
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 13, 2020 at 09:23:22AM -0400, Jeff Layton wrote:
> > > I don't see a problem with having a "free" routine ignore IS_ERR values
> > > just like it does NULL values. How about I just trim off the other
> > > deltas in this patch? Something like this?
> > 
> > I think it encourages fragile code.  Less so than functions that
> > return pointer, NULL or IS_ERR pointer, but still.  You yourself
> > almost fell into one of these traps while editing debugfs.c ;)
> > 
> 
> We'll have to agree to disagree here. Having a free routine ignore
> ERR_PTR values seems perfectly reasonable to me.

Freeing things which haven't been allocated is a constant source bugs.

err:
	kfree(foo->bar);
	kfree(foo);

Oops...  "foo" wasn't allocated so the first line will crash.  Every
other day someone commits code like that.

regards,
dan carpenter

