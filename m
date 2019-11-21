Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88907105C26
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 22:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKUVlj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 16:41:39 -0500
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:12980 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUVlj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 16:41:39 -0500
X-Greylist: delayed 969 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2019 16:41:38 EST
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALLAiui021569
        for <ceph-devel@vger.kernel.org>; Thu, 21 Nov 2019 16:25:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version : from
 : date : message-id : subject : to : content-type; s=proofpoint;
 bh=IJ5JFKp7qKPfwv8OVoCwrAvwLAd4jOxNTjUF2X40hlI=;
 b=R8Bpx3+JQX8ZgolwW9HNvcSVrZ6XAevl/NBb8CKkMS7YXQaMM/Gl7dgUsnUFEefrwinv
 mNq0E/uDko8+EaLyIKVRrpRKzBYXEZbi7T8Wvqscp7Z8UcuyGtRQ8jwGpgo0JUU1MUr3
 lMal56M/wpCYDLFF9e/cGQXm+gBKAuC1VZhFWAq2LB7jzyJJwgCK6OoJNYUGOJs5qN7Z
 IibUOqLPs9bwHOEWrFfwcd7agV4rF09AkUGY0uqRKJfyBB5Q/TEifycX1E4r1KR/CMgs
 Twe5ZuoTEdlYL8LCRhM6N+PWCxP6eSHWyNXmPvtFAPM9voRBpXD2+0C4bqczn4pvJ2q7 3g== 
Authentication-Results: seagate.com;
        dkim=pass header.s=google header.d=seagate.com
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        by mx0a-00003501.pphosted.com with ESMTP id 2wayb313pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <ceph-devel@vger.kernel.org>; Thu, 21 Nov 2019 16:25:28 -0500
Received: by mail-ed1-f69.google.com with SMTP id a3so2580067eda.0
        for <ceph-devel@vger.kernel.org>; Thu, 21 Nov 2019 13:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=IJ5JFKp7qKPfwv8OVoCwrAvwLAd4jOxNTjUF2X40hlI=;
        b=Wl3k4PhmDTOpE1rmPyFVpkTxtDGSz+NrCeqixf8VNSNEpn78lTvzaeRq6EwHl19Fh+
         /jFjoR9gw1bPtiN+RyXkC6kpzJunYrt322xCtsmv2UzG7V8+53teGzfCKlu4SwSozWwS
         TTVJ+3fuZuvI7HJg+7iQPqn7LoE/YHSy+TTzE3pU1jIlwsSDWpI2o03zDch501qabGJV
         V/U4bfVTdvLT5ZE8B+AZ3YVU1XLP06smSqPF85wfvLgjbRoW3kiEwbkQeid5QpsmM9Ls
         HrlVv0WdQoTSE4w3+FxLJckOT1px+sj7TYWLfYy1O+b6hwMnaRApQOZFJhbtAh9u3vkn
         qOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IJ5JFKp7qKPfwv8OVoCwrAvwLAd4jOxNTjUF2X40hlI=;
        b=tl5x1EjuLHxoYsVnfC378ErxQs1m5nyZ2iu7OGOO5OfwSMUceyp0g3M4/Yhkctwqge
         yM3gmjzSVUGFhsvvzKIdrsGPBfeOUfBOnuADh+Biw7sNcDTr3ym2C9ieh/Idnu6Weiz6
         BT/oGsriYJboPxRYPFvI14ATEQ//zvCpRh5D1oGpIMKRGkvM50XWNz2ly3sE7qoyfG3W
         Rob2wemisNpkV3EU9LsRL3qY34gZCVL4652d1BfjdaQPJ1lVM1LJPGVmGht3ZrF95/ut
         ijYgoGlWLfacWpu0hXryiWM8prwJ7Uo7n+xpiAaU3KjXYVqmte3y0mFMfKOCGTyr/RVM
         ApUw==
X-Gm-Message-State: APjAAAWo43uMgxZviR4v38xJazlt6wSvt0ehM5r0bi1TsedEd5AKsxgW
        zG/MK25JL+QRrn4VKtk7xBKS04seG4si5bdvKpMLYvALpsv9HCGkFCiCNXerdDgj/m6sEaq8yeL
        fRmjkN4kBblPAivzUURD8D/X7r4ggFgouW9UTvB0plOmVf8ArIhHL1kb1XBpUKgg=
X-Received: by 2002:a17:906:7e41:: with SMTP id z1mr16417014ejr.63.1574371526568;
        Thu, 21 Nov 2019 13:25:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5HtQYjLWKwmsPFUIwXDQP6LVGrP6H1pkmDPzMvtwt2K0h3UMOxKUjCYeQMF6en6KdstXJZi0yXLl5uPIQ78w=
X-Received: by 2002:a17:906:7e41:: with SMTP id z1mr16416980ejr.63.1574371526223;
 Thu, 21 Nov 2019 13:25:26 -0800 (PST)
MIME-Version: 1.0
From:   Muhammad Ahmad <muhammad.ahmad@seagate.com>
Date:   Thu, 21 Nov 2019 15:24:49 -0600
Message-ID: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
Subject: device class : nvme
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_06:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 phishscore=0 clxscore=1015 mlxlogscore=658 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911210177
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While trying to research how crush maps are used/modified I stumbled
upon these device classes.
https://ceph.io/community/new-luminous-crush-device-classes/

I wanted to highlight that having nvme as a separate class will
eventually break and should be removed.

There is already a push within the industry to consolidate future
command sets and NVMe will likely be it. In other words, NVMe HDDs are
not too far off. In fact, the recent October OCP F2F discussed this
topic in detail.

If the classification is based on performance then command set
(SATA/SAS/NVMe) is probably not the right classification.
