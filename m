Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1996D3EF0
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Apr 2023 10:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjDCI2P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Apr 2023 04:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjDCI2O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Apr 2023 04:28:14 -0400
X-Greylist: delayed 818 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Apr 2023 01:28:13 PDT
Received: from mail.arnisdale.pl (mail.arnisdale.pl [151.80.133.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33E946A5
        for <ceph-devel@vger.kernel.org>; Mon,  3 Apr 2023 01:28:13 -0700 (PDT)
Received: by mail.arnisdale.pl (Postfix, from userid 1002)
        id BE3A425532; Mon,  3 Apr 2023 08:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=arnisdale.pl; s=mail;
        t=1680509310; bh=6DhEsVYOGxxfetVY3oiVeew+7Cm34ArcvgDq2WQYIRw=;
        h=Date:From:To:Subject:From;
        b=sntb7poHF0anzbM0S1tuCNfMC/rR4H+uX6dM+mRIQDbdyDQl9Ono89ik1FeYSmJNN
         treVUMBnMZivDBCnAn4Ho/UFu387XxnyRKOLbC5YC6gTU/CNL6vbHtW5TgSsEHN2IR
         hwNN6/zSRbslehkX4VGcK5EtjjUZHCChM2SXM3S2RYCl8AYqmeFjp+GrYLQbXFNqDe
         rnibhxyiHVAcQpt40F16JR+Om/B/LG8OJJD3T1D9dXgkob//VB34gKN78qbjULDNCd
         7MH/jmJOQ7prQG68qBwLmWbSsFKDf8ZQuXVncFKm4CdlqLOfKL+q2BpKsnpt8JjQxl
         KkYOGnhY9IKvg==
Received: by mail.arnisdale.pl for <ceph-devel@vger.kernel.org>; Mon,  3 Apr 2023 08:05:59 GMT
Message-ID: <20230403064500-0.1.3p.18vks.0.7wcmq5fsds@arnisdale.pl>
Date:   Mon,  3 Apr 2023 08:05:59 GMT
From:   "Maciej Telka" <maciej.telka@arnisdale.pl>
To:     <ceph-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Nawi=C4=85zanie_wsp=C3=B3=C5=82pracy?=
X-Mailer: mail.arnisdale.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_NONE,SPF_PASS,URIBL_CSS_A,URIBL_DBL_SPAM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_SPAM Contains a spam URL listed in the Spamhaus DBL
        *      blocklist
        *      [URIs: arnisdale.pl]
        *  3.6 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [151.80.133.87 listed in zen.spamhaus.org]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: arnisdale.pl]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [151.80.133.87 listed in bl.score.senderscore.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dzie=C5=84 dobry,

Czy jest mo=C5=BCliwo=C5=9B=C4=87 nawi=C4=85zania wsp=C3=B3=C5=82pracy z =
Pa=C5=84stwem?

Z ch=C4=99ci=C4=85 porozmawiam z osob=C4=85 zajmuj=C4=85c=C4=85 si=C4=99 =
dzia=C5=82aniami zwi=C4=85zanymi ze sprzeda=C5=BC=C4=85.

Pomagamy skutecznie pozyskiwa=C4=87 nowych klient=C3=B3w.

Zapraszam do kontaktu.


Pozdrawiam serdecznie
Maciej Telka
