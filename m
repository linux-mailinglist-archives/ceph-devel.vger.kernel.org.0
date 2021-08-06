Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1113E2C39
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Aug 2021 16:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbhHFOLW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Aug 2021 10:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbhHFOLB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Aug 2021 10:11:01 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DEBC0617B0
        for <ceph-devel@vger.kernel.org>; Fri,  6 Aug 2021 07:10:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hs10so15372670ejc.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 Aug 2021 07:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/oMubRmlLM5EZ/UdY6Fj3wsfS2kyoMzN9ASXgZ3xneY=;
        b=q3xyYt1HrVQnyL1KZndhIFKim0Z6RZXWCajZa6+jKaUt/xPBmWrU2b2TpwIqgxHoY3
         6sUeXJPoUC3zz+xqx5Y/7bh16ON7BcCcP2liy5jl/yv+hyxVGmxIcBCDJXoapuOO0RIl
         REN9Zv+ClhtVVEMybVDTEUTnyt+YraWqvgNO4CiPEvSNbjJp0ymaQzc4FwPALfOqM4La
         f+KzIMXFoGuca5XlZdCXXnnqi+xUiOGsem/cV9JUjNFonSZWOzEGazowyEr2eG3dp5DR
         pLBa7cN2FmOkeXw/dSFAaB7k29Eu0Yivashc8iQbXHlro4ZoI7aiyRP21+G8wGDlMmu6
         HPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/oMubRmlLM5EZ/UdY6Fj3wsfS2kyoMzN9ASXgZ3xneY=;
        b=jTLGwrBasXQSsHtJD2MYTrPhxSNgfzRTIkuhtGZBRoKZJPQJ0JugKlw4552z5UE+kr
         nO+kAu39Fulfhg3CDA4Cp7KijE1Lw9wTWg3lQTPqUcQ5KH5FiF8GroJ1FjA0awzEZbT5
         fVBB8HYdE7ktB8GeX3RqOGUEDNuB3j8KSFBduOHyiEAhTOnMMpn7mB0fT3LUg+3Cx9Ac
         jUpD3gt4uGyyTgEEqnEG8i+CchoysSe4d7DEKFRSsCGwgbrlaeLwCA7o8tm5+aclsWym
         u7Lt96GF5uxv+W21HawUR0MrAM4/Sy80RWjEJQb9fQl3ssdyR+z1Kw/8UMH2kee9OAc1
         C/nw==
X-Gm-Message-State: AOAM531rFh2mGc4xpyKdNAOviKHImDFtkCxL3CZ6Jngs4SBsskMnaIZg
        4RY6/btQEMhdWfSumaCdj4mCU4J278sD/aejTbyoomTK13YJgv0bDQ==
X-Google-Smtp-Source: ABdhPJx229jhz+o+nQwdgIkoqR5HwLh3S4+JGHt0eG+5fB4X3WTmNmInTj1ZpuXDIVm9CYEhhFZzLyuZYbLrplGdX6A=
X-Received: by 2002:a05:6402:3094:: with SMTP id de20mr13526197edb.272.1628259031175;
 Fri, 06 Aug 2021 07:10:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:26cf:0:0:0:0:0 with HTTP; Fri, 6 Aug 2021 07:10:30 -0700 (PDT)
Reply-To: mrmaxwellwatford@gmail.com
From:   Maxwell Watford <orchowskiruthi@gmail.com>
Date:   Fri, 6 Aug 2021 14:10:30 +0000
Message-ID: <CA+q9Q6OJB6Z0+y=5_3MBDNGkAUG9rVxg7bZVma38uDOvJ+sOGw@mail.gmail.com>
Subject: i need your reply
To:     orchowskiruthi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Greetings,

We are writing to you from Ecowas Finance Controller Office Lome Togo,
because we have received a file from the Ministry of Finance Lome-
Togo, concerning an Inherited Fund bearing your name on it, And after
our verifications, we found out that the funds belong to you.

It has been awarded and I will like to guide you to claim the funds.
Please contact me at my private email address
(mrmaxwellwatford@gmail.com) for more information and directive

I am looking forward to your urgent reply,
Best regards
Mr Maxwell Watford
