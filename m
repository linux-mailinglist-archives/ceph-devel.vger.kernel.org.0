Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466F035F02F
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Apr 2021 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349855AbhDNIvs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Apr 2021 04:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244803AbhDNIvr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Apr 2021 04:51:47 -0400
Received: from outbound5.mail.transip.nl (outbound5.mail.transip.nl [IPv6:2a01:7c8:7c9:ca11:136:144:136:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35328C061574
        for <ceph-devel@vger.kernel.org>; Wed, 14 Apr 2021 01:51:26 -0700 (PDT)
Received: from submission5.mail.transip.nl (unknown [10.103.8.156])
        by outbound5.mail.transip.nl (Postfix) with ESMTP id 4FKx643HHNzHCNd
        for <ceph-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:51:24 +0200 (CEST)
Received: from exchange.transipgroup.nl (unknown [81.4.116.215])
        by submission5.mail.transip.nl (Postfix) with ESMTPSA id 4FKx6221Cnz7tFr
        for <ceph-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:51:22 +0200 (CEST)
Received: from VM16171.groupdir.nl (10.131.120.71) by VM16339.groupdir.nl
 (10.131.120.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3; Wed, 14 Apr 2021
 10:51:21 +0200
Received: from VM16171.groupdir.nl ([81.4.116.210]) by VM16171.groupdir.nl
 ([81.4.116.210]) with mapi id 15.02.0792.013; Wed, 14 Apr 2021 10:51:21 +0200
From:   Robin Geuze <robin.geuze@nl.team.blue>
To:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: All RBD IO stuck after flapping OSD's
Thread-Topic: All RBD IO stuck after flapping OSD's
Thread-Index: AQHXMQs7yqmta0olA0ygBmx0d4s7EA==
Date:   Wed, 14 Apr 2021 08:51:21 +0000
Message-ID: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
Accept-Language: en-GB, nl-NL, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.4.116.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: ClueGetter at submission5.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=nl.team.blue; t=1618390282; h=from:subject:to:date:
 mime-version:content-type;
 bh=xt1gocxx81ms8j9XFvAPSi0er1OCVxFpIPRLVgUejSA=;
 b=V2EqqgTjmrHaoKMHQ47GlgLmFv25Rlu73NpVP+pu4bWZ9R4R0KqiFKRg4938dR/910fsE9
 BAWVNKRu4gxVxgveLfxaYU660qsLC5xWojxzntbRq4j+vptJLcqWS2kGdRWy0ww0wzcNxO
 OHBTximC3oH/rjgh1RbGCbUzYNvPMWjnaCVN3k58HMOtYMcv7l78REym4DwqhtbGIsou0s
 3Dhr/VtVUMX9mszHsjuCKwwCDJYz6m/0YR9SXoamTIc4SchhIlB5X6EuGD110NfR8JAls5
 KoVsptlwN6Loaun6B3+HV1b3eSIc0MpBS/5hnnur16njehtK70BIom6lMIjyEg==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey,

We've encountered a weird issue when using the kernel RBD module. It starts=
 with a bunch of OSD's flapping (in our case because of a network card issu=
e which caused the LACP to constantly flap), which is logged in dmesg:

Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
(...)

After a while of that we start getting these errors being spammed in dmesg:

Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre object map upda=
te failed: -16
Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at objno 192 =
2564096~2048 result -16
Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write result -16

(In this case for two different RBD mounts)

At this point the IO for these two mounts is completely gone, and the only =
reason we can still perform IO on the other RBD devices is because we use n=
oshare. Unfortunately unmounting the other devices is no longer possible, w=
hich means we cannot migrate our VM's to another HV, since to make the mess=
ages go away we have to reboot the server.

All of this wouldn't be such a big issue if it recovered once the cluster s=
tarted behaving normally again, but it doesn't, it just keeps being stuck, =
and the longer we wait with rebooting this the worse the issue get.

We've seen this multiple times on various different machines and with vario=
us different clusters with differing problem types, so its not=A0a freak in=
cident.=A0Does anyone have any ideas on how we can potentially solve this?

Regards,

Robin Geuze=
