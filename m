Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC863CE97C
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jul 2021 19:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351703AbhGSQ44 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jul 2021 12:56:56 -0400
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:49032 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357644AbhGSQwL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Jul 2021 12:52:11 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 12:52:11 EDT
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id C6F8520763
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 17:24:55 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 137A0260EB
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 17:24:53 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id 613263F203
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 17:24:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 4A6032A351
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 13:24:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1626715487;
        bh=KPxL3izNhQ9kKzo4uqH8SB4w/lxUHsI2qvYMz4NTUBQ=;
        h=From:To:Subject:Date:From;
        b=MvJXGEw4nu8bT9OfBU6EwpMym1z6et6kqrebyzTYoy49rBkaGEqiOVnhexD8Fs4gq
         fnEv5UwfX5doGQAnqO2iwL5C2apukh553Hw9Vc/NoaGNRgpKFzIhwcq0oc3Rj9h2Xq
         W/1wQ6+GNWJZ1GEjLJ7yiTIYcPaJYB9GxEdsa7OM=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D_EFFgNZTNgS for <ceph-devel@vger.kernel.org>;
        Mon, 19 Jul 2021 13:24:46 -0400 (EDT)
Received: from mail10.mymailcheap.com (mail10.mymailcheap.com [51.68.115.196])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 13:24:46 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail10.mymailcheap.com (Postfix) with ESMTP id 4B811200A6
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 17:24:45 +0000 (UTC)
Authentication-Results: mail10.mymailcheap.com;
        dkim=temperror (0-bit key; unprotected) header.d=beststartup.us header.i=@beststartup.us header.b="z8GWZrXP";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from core04.farm.integromat.com (core04.farm.integromat.com [82.208.14.113])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail10.mymailcheap.com (Postfix) with ESMTPSA id 444CD200A6
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jul 2021 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=beststartup.us;
        s=default; t=1626715480;
        bh=KPxL3izNhQ9kKzo4uqH8SB4w/lxUHsI2qvYMz4NTUBQ=;
        h=From:To:Subject:Date:From;
        b=z8GWZrXPGvRFHwE2SO6Or+MrPyNSFq7NxyTcseUgGbcOzp55Zh0n/sFfNhJtiizO9
         +9RKGaK+8bvrZGnsOpBpvsCFfuAV0Sj/5790LU+Wls3CkzKxmwPs6sM0aY9vgYQ+F0
         Ew0Vz7jQzU5Z0HIz9J162vQX6TxZTWRDHajjsZZY=
Content-Type: text/plain; charset=utf-8
From:   Mark <outreach@beststartup.us>
To:     ceph-devel@vger.kernel.org
Subject: Article featuring your company...
Message-ID: <4fc666e3-052f-bacf-ef20-cb322be5a8c5@beststartup.us>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 19 Jul 2021 17:24:39 +0000
MIME-Version: 1.0
X-Rspamd-Queue-Id: 4B811200A6
X-Rspamd-Server: mail10.mymailcheap.com
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_SPF_FAIL(0.00)[-all];
         R_DKIM_ALLOW(0.00)[beststartup.us:s=default];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         TO_DN_NONE(0.00)[];
         PREVIOUSLY_DELIVERED(0.00)[ceph-devel@vger.kernel.org];
         RCPT_COUNT_ONE(0.00)[1];
         DMARC_NA(0.00)[beststartup.us];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[beststartup.us:+];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear Ceph Storage,

I hope your business is prospering.=C2=A0

I=E2=80=99m just reaching out to let you know we mentioned Ceph Storage in =
our article about Enterprise Software companies in Los Angeles (LA).=C2=A0

The article can be found here: https://beststartup.us/?p=3D6871. I hope it =
drives some sales to your company. Any shares on the article would be =
greatly appreciated.=C2=A0

If you want to get some broader promotion from =
our network you can write and publish an article on your blog/website =
titled something like =E2=80=9CWe Were Nominated as a Top Enterprise =
Software Company in Los Angeles (LA) by BestStartup.us=E2=80=9D. If you =
send us a link to that post we will share it across our network and tweet =
it out.=C2=A0

If you want to check out our media pack, it can be found =
here: https://beststartup.us/media-pack/=C2=A0

Thanks,
Mark

BestStartup.us is a subsidiary of Fupping Ltd, a UK (London) based media =
company. P.S. Feel to follow us on: Linkedin: Search "BestStartup.us".
