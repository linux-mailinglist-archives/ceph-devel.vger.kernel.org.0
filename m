Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F9930C18D
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 15:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhBBO1g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 09:27:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbhBBOWZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 09:22:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112EJ3hB162338;
        Tue, 2 Feb 2021 14:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=4GVlHHWGh41eOory0P9S0N78v8JiUWK8468ERwtQqo0=;
 b=Yz8orsYYlkvbyNmgIffZtb8m8aOjoKiXxkJJS66VJ73d+w+hFCaHQSgR0FYRJ7CNNlAH
 zYKaKYW2rf9ucmGVu0/krO1lTrFu3D/3s56xE5kbUpFMW+0Lxi1ByvUmvsQhXiB8JIOU
 FtsAodsok8f7+eKHic778jMzK1v7Yrkqb7Qx+RtN3hIsyDtJStWL+Ko5fxSupEPh0AF/
 NkHxQD9n7gDWdzTWCwVkJ8ZQhgmJxITXKmryN6EhLlnbz7ntw8Xx+46m0Np8e6ITQz2V
 c0VvRK8Fdg+vC5aBDnW/SLDIlnkCLZQStwx/ZnpaRohuN+jabg7+3vFx3BS4pagKSi5e rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydktxfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 14:20:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112E9UZd018082;
        Tue, 2 Feb 2021 14:20:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 36dh1p3aw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 14:20:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 112EK54x011054;
        Tue, 2 Feb 2021 14:20:05 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 06:20:04 -0800
Date:   Tue, 2 Feb 2021 17:19:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: Fix an Oops in error handling
Message-ID: <20210202141957.GC20820@kadam>
References: <YBjne8A1gn0mvQtT@mwanda>
 <f0477211cafbdc24883e978ab976610333f5fb67.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0477211cafbdc24883e978ab976610333f5fb67.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020098
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 02, 2021 at 07:37:57AM -0500, Jeff Layton wrote:
> On Tue, 2021-02-02 at 08:47 +0300, Dan Carpenter wrote:
> > The "req" pointer is an error pointer and not NULL so this check needs
> > to be fixed.
> > 
> > Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  fs/ceph/addr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 5eec6f66fe52..fb0238a4d34f 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -273,7 +273,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
> >  	if (err)
> >  		iput(inode);
> >  out:
> > -	if (req)
> > +	if (!IS_ERR_OR_NULL(req))
> >  		ceph_osdc_put_request(req);
> >  	if (err)
> >  		netfs_subreq_terminated(subreq, err);
> 
> Good catch.
> 
> David, could you take this into your fscache-next branch?
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Jeff sent a different fix for this.  Let's just apply his instead.

regards,
dan carpenter
