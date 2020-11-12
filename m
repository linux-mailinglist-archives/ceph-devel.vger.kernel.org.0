Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371752B083E
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 16:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgKLPR7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 10:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgKLPR6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Nov 2020 10:17:58 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1A5C0613D1
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 07:17:58 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c20so4804018pfr.8
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 07:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ByBpsYUeNJE4F9ozX9/ObO8RQeu8DVYKPnXQJuXBxAM=;
        b=qUNKtnFYCrOff6w+Wb+WMmPQROdAdvA1eg6gP7UhDE4i5vhrCOi/zPsOXaXuFx4sWA
         4utlxoW9Us0XcSaqltcHUNhv9LzOO/ucnfMGN4Y7OXRJOsiX2LxuQDKC9BYCawoECSAI
         DzIZUlK3YpXwyXGNgWogIPc5wTJGQC5/PtEDgtGeLfVMrVfQOQhBnPXIhtHCMTJ+vmSi
         NvADSomCvnhh6FDMNU/COAAQyGwCn8RwJ0j0kU8M2pA26MqlFa6EQEFU+7+ECn4zgBO8
         ssQPxVWbsXoORLa0eGuA6fgg+VWk3PG/Yl6AZuKo+6qS5j432EaK6vPCHicM/ZKgaU/u
         AFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ByBpsYUeNJE4F9ozX9/ObO8RQeu8DVYKPnXQJuXBxAM=;
        b=P6myBlQopylbpu2mZ/tSEWGjGtW7VvOrS4y90T0rBwBE+5F5jphHS1XirMwg7Zf+i6
         iZgnq7gEjCpw0jJtALSXSUEelCi68xoer8Dy/fbCSzd43+tSOVrF2F0djul6zoDqNe/U
         DzLT7sf9waP8oSBc1k1pX9odL292UukY8byA3YWBQxeZuB/hCqTmMVU1nzL33ytkkV+1
         2KtToViYJ5VIqgxlUTZeCiecBc6mUzNNrDNM0T+2g1F6Yw+uNqwKg5mPDz3SssSUFjgQ
         TIURKM/pOJh8NMDEkqjjqPUAScWvaXLckPDGnX6NOkPbqtRkwARZ/FqNam1IzIKndDNr
         TJFQ==
X-Gm-Message-State: AOAM532qdFKj0Su+rJz0BynbPamsA6lNElZhh+5aYyJlLZneMDsYMzR6
        f2herV6dOU67ZJTdXNNKOAsQ25kodlhuLTHCz2HDHWQ/yOJlww==
X-Google-Smtp-Source: ABdhPJynaav1i22EqbCswcyALbTwpiqzMOaTjy2tFpjb86WmajNcC2MP9bn9zt0Uedx9nNGniIVuUigk1nV7tSOHy2A=
X-Received: by 2002:a62:834a:0:b029:18a:e0b1:f0d9 with SMTP id
 h71-20020a62834a0000b029018ae0b1f0d9mr43580pfe.73.1605194278336; Thu, 12 Nov
 2020 07:17:58 -0800 (PST)
MIME-Version: 1.0
From:   Sage Meng <lkkey80@gmail.com>
Date:   Thu, 12 Nov 2020 23:17:45 +0800
Message-ID: <CAF8vKShnH+xas+kLAcXL-Cxt6C3TF7TbP4Wfm0h48pEGCmsR+w@mail.gmail.com>
Subject: Is there a way to make Cephfs kernel client to send data to Ceph
 cluster smoothly with buffer io
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi All,

      Cephfs kernel client is influenced by kernel page cache when we
write data to it,  outgoing data will be huge when os starts to flush
page cache. So Is there a way to make Cephfs kernel client to send
data to ceph cluster smoothly when buffer io is used ? Better a way
that only influence Ceph IO not the whole system IO.
