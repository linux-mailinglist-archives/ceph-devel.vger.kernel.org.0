Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089FA1097E0
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 03:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfKZCkF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 21:40:05 -0500
Received: from mailer.magnus.net.ua ([193.111.114.9]:60524 "EHLO
        mailer.magnus.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfKZCkF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Nov 2019 21:40:05 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2019 21:40:03 EST
Received: from localhost (localhost [127.0.0.1])
        by mailer.magnus.net.ua (Postfix) with ESMTP id 5172E2B02C4D;
        Tue, 26 Nov 2019 04:32:47 +0200 (EET)
Received: from mailer.magnus.net.ua ([127.0.0.1])
        by localhost (mail.mgn [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id T-u2erMNInaU; Tue, 26 Nov 2019 04:32:45 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
        by mailer.magnus.net.ua (Postfix) with ESMTP id 4DA0E2B02B15;
        Tue, 26 Nov 2019 04:32:45 +0200 (EET)
X-Virus-Scanned: amavisd-new at mail.mgn
Received: from mailer.magnus.net.ua ([127.0.0.1])
        by localhost (mail.mgn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6QzJwodkntRm; Tue, 26 Nov 2019 04:32:45 +0200 (EET)
Received: from mail.mgn (localhost [127.0.0.1])
        by mailer.magnus.net.ua (Postfix) with ESMTP id 324FE2B02960;
        Tue, 26 Nov 2019 04:32:45 +0200 (EET)
Date:   Tue, 26 Nov 2019 04:32:45 +0200 (EET)
From:   Fyodor Ustinov <ufm@ufm.su>
To:     M Ranga Swami Reddy <swamireddy@gmail.com>
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Message-ID: <1067131621.54855.1574735565028.JavaMail.zimbra@ufm.su>
In-Reply-To: <CANA9Uk4kmPqe6z17BUCnUuJyNcQkOqEcwXv+RLOsbKS-bmsyGw@mail.gmail.com>
References: <CANA9Uk4kmPqe6z17BUCnUuJyNcQkOqEcwXv+RLOsbKS-bmsyGw@mail.gmail.com>
Subject: Re: [ceph-users] scrub errors on rgw data pool
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.129.169.218]
X-Mailer: Zimbra 8.8.15_GA_3888 (ZimbraWebClient - FF70 (Win)/8.8.15_GA_3890)
X-Authenticated-User: ufm@ufm.su
Thread-Topic: scrub errors on rgw data pool
Thread-Index: eq0E/lTW8OzdZou4dgOX7fApxYyr7g==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

I had similar errors in pools on SSD until I upgraded to nautilus (clean bluestore installation)

----- Original Message -----
> From: "M Ranga Swami Reddy" <swamireddy@gmail.com>
> To: "ceph-users" <ceph-users@lists.ceph.com>, "ceph-devel" <ceph-devel@vger.kernel.org>
> Sent: Monday, 25 November, 2019 12:04:46
> Subject: [ceph-users] scrub errors on rgw data pool

> Hello - We are using the ceph 12.2.11 version (upgraded from Jewel 10.2.12 to
> 12.2.11). In this cluster, we are having mix of filestore and bluestore OSD
> backends.
> Recently we are seeing the scrub errors on rgw buckets.data pool every day,
> after scrub operation performed by Ceph. If we run the PG repair, the errors
> will go way.
> 
> Anyone seen the above issue?
> Is the mix of filestore backend has bug/issue with 12.2.11 version (ie
> Luminous).
> Is the mix of filestore and bluestore OSDs cause this type of issue?
> 
> Thanks
> Swami
> 
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
