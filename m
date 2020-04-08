Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD51A22F2
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgDHN1x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 09:27:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgDHN1x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Apr 2020 09:27:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038DO5Pr032814;
        Wed, 8 Apr 2020 13:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+GEDXdlFOTif1bySh4ewU3CV6JP8kFk9FPMAYYa3z00=;
 b=a03GpncYrqubFCD0w9cbKUDTvwByrrbsg0chB0uoZzdHXLAtPvoZkXx/hCSRcWe2VLtL
 ad7IsUAc7pSQuJsZMfT5JSp30m+FXnHeM5+yBzR0is+gawyZnc1XvBB4oYB6ko51pcGU
 l5f99xYF3MUWilzBaQcSqgug1b5wkYWD/XGFUvOkFVeGSeRD1l0Wt+07NrEzHyzYbIh7
 lSTAaRlANjhRqZvLA7jdkW1e5RMgVeQejcWV9Zpg+tfaIxgnvDfq7ohFcCHu6BUeppN9
 3RTaQSW0C5jiJcPEuuG3/o0VMv3nygsm1RaNTGhqfUtmO5Vd4C0AGPQxdP/fPepGiM6/ 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3091m3bh69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 13:27:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038DRMbo139234;
        Wed, 8 Apr 2020 13:27:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3091m10pna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 13:27:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038DRmVR006323;
        Wed, 8 Apr 2020 13:27:48 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 06:27:47 -0700
Date:   Wed, 8 Apr 2020 16:27:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Subject: Re: [bug report] ceph: attempt to do async create when possible
Message-ID: <20200408132741.GO2066@kadam>
References: <20200408111734.GA252918@mwanda>
 <20200408112201.GN2066@kadam>
 <7114ea60738d083e618ac35beb840afeea74fce1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7114ea60738d083e618ac35beb840afeea74fce1.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=2
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080111
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 08, 2020 at 08:48:05AM -0400, Jeff Layton wrote:
>
> Sound ok?

Sounds good.

>  fs/ceph/mds_client.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 1b40f30e0a8e..754e0682398e 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -531,7 +531,7 @@ extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>  
>  static inline void ceph_mdsc_free_path(char *path, int len)
>  {
> -	if (path)
> +	if (path && !IS_ERR(path))

if (!IS_ERR_OR_NULL(path)

>  		__putname(path - (PATH_MAX - 1 - len));
>  }
>  
> -- 
> 2.25.2
> 

regards,
dan carpenter

