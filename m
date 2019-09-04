Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70330A92B9
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2019 22:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIDUBb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Sep 2019 16:01:31 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:36132 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfIDUBa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Sep 2019 16:01:30 -0400
Received: by mail-ed1-f41.google.com with SMTP id g24so208216edu.3
        for <ceph-devel@vger.kernel.org>; Wed, 04 Sep 2019 13:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DFFaPoFGXkNYIZiMwKOWKppZhbCVhbhjlQsfGcwOiRE=;
        b=XAYW1SwUfYaKha4wPMl0XlPxAMVLB1TWo+4QIrt6fX1x9lF557d3jv2BedgmttrFEc
         L5fAT4LFssxPNU82vwIPE4lik08fj74/zwlesjzc3LxIFcnrWWBNjajcMILAJ5KPmiMh
         bkVEqMcl0hTvKIGCr7AE7j9hfX6kAi4tkbhsiJ4jNEU3Sfyjvv9n9bHrNddazXi5kxpK
         fGVmZQ8+Fpasg3m+j03xexexNjHiaMUIeqUNCDssiqMXCRdRer7qpd2cIerXv3m6Inye
         SS7YglBJ6Z9Px0wQPLL+nUEug1SGRM+ZOCF1mwgx+1AgU9MZZzH9RgjewN5FTUQ1s7ZP
         Ko8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DFFaPoFGXkNYIZiMwKOWKppZhbCVhbhjlQsfGcwOiRE=;
        b=bOk3eSYoFoJ0lvOJ/8MkLntI2ciRkPyQcE26IVNx/13p1ic966tfcndnoPDn6kxIqK
         c89gpHqAdBMCgVsa9pMRVEXKqU9ak+70COjXU7rWcMVjxoBcQ0aI3TYFZv3VPSzNFJbQ
         8z64jflu5x6H5FpZHjSlD7uhYiSbwp/Du9lhqn+E7B1UtGR+Mrd100hnY3POgHroEVX7
         2geCrJ4nmpC/w/VRz9N5TA332tCo9eAeK6GJUOalSVChYxjAhowQS7pZvj9Mx6nrgL1P
         WjYbugMZrCYStOCZ1CkHWAAuXlrE4swME9muOfqAW+MPPhZV5nT2GmfbXpiYN+F81u6y
         wzhA==
X-Gm-Message-State: APjAAAXN5325+X/VoxMNef4rro+s8GAtxYvD49WVbET7bOcQAeknoiTG
        qmgniRouY9U7IutZ3Wvw34ezBvr7xi49FHfX3T0f3+9jDEuFtA==
X-Google-Smtp-Source: APXvYqx3GDvQ1X6N/MH29Vitt2/hk1Ez1FXqmSEudlyoHYFillLMV0vE+rwPWZZ1WPzdpS43vYWLsSFQEGvQn/2wkNA=
X-Received: by 2002:aa7:d95a:: with SMTP id l26mr10623416eds.297.1567627288447;
 Wed, 04 Sep 2019 13:01:28 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Emmerich <paul.emmerich@croit.io>
Date:   Wed, 4 Sep 2019 22:01:17 +0200
Message-ID: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
Subject: ceph-volume lvm activate --all broken in 14.2.3
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

see https://tracker.ceph.com/issues/41660

ceph-volume lvm activate --all fails on the second OSD when stderr is
not a terminal.
Reproducible on different servers, so there's nothing weird about a
particular disk.

Any idea where/how this is happening?

This makes 14.2.3 unusable for us as we need to re-activate all OSDs
after reboots because we don't have a persistent system disk.


Paul

--=20
Paul Emmerich

Looking for help with your Ceph cluster? Contact us at https://croit.io

croit GmbH
Freseniusstr. 31h
81247 M=C3=BCnchen
www.croit.io
Tel: +49 89 1896585 90
