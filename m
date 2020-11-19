Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2759C2B905F
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Nov 2020 11:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKSKrF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Nov 2020 05:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgKSKrF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Nov 2020 05:47:05 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23237C0613CF
        for <ceph-devel@vger.kernel.org>; Thu, 19 Nov 2020 02:47:05 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id w8so4886875ilg.12
        for <ceph-devel@vger.kernel.org>; Thu, 19 Nov 2020 02:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67mG5BiVtG26o1rO1Vao56j4O5aeDnx+JUSM05uBmQU=;
        b=gOsRg310Zx99denqIlc+waaLaAUTv5MJlrBsq9Vwgb0tZIYAqx1vwzQViVjc1fPuNO
         ZeijpUEwetwB9GL0dK+TSNDzzawcawrlqa6XJhODPL4qEzeyy8wUd3xBKHqgqu4Chhzg
         qgNdcWaOpjU0USkKykI9pZvy1Jf0eo3+6GW9EFqTF8Inx7M8tPMh8LxwweKBxrs3ueh+
         QVAXoUSzi9ZS5vG5TA1+qRKriEBmfTyKy9HEhmqJS+8aQwLc1q1+scm/0Pw33GM+ezEV
         YTxEPHtqlnf8HW4d/oVviJXy1JICoYDt+F4nuFdDcthLaCwJMjsvjzu724vYe8ygDeks
         HePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67mG5BiVtG26o1rO1Vao56j4O5aeDnx+JUSM05uBmQU=;
        b=CLPgxPulqL/xB6h1MWsyWVqDGYFPqzg3QaLIyXWgKc0W0f5YdGomTD0fOO3asYYY8M
         JBopR4P0QNoKlcmDOni9neOVKr/2tbC7EesU7jupN7QlyI2nNFx7qi5bl9R1e10UfW9a
         qN8QsVNL/9Lze7ONTG90gIXAUiAA1eR/lT1p6AhtOUqh0WdYOuWoodBgrpptWF069njC
         828MMvjXU7CIGfR9NqUgJTJzj4rD63MOUrCrA4CtwqihZ3KSUOZL7MMcpRSiJj9ve+A9
         PGjkz0Q8GgHdtV4QZdFYZgLO0ZBhRHZrJD/E/OqLXQBBhQvqJ1ca1bcSI4f3hnK9h3Up
         1JGA==
X-Gm-Message-State: AOAM530k+9bjUYxlQU+YFXqM7PG93tL/LM/fyWEKRCYMG/jZWa/OqIx5
        8OBTfUFPTga0ZaNh0U8saKEKkk7tyOyn5pzbYoObticZTpEMsw==
X-Google-Smtp-Source: ABdhPJzetuePvgnLRhLAOt+kor/QGeaGDJUJlB964XaX5NYXCdJLjjFhgzmUd5twmnyCCSshsJ4TWsY19qIySsQp8gA=
X-Received: by 2002:a05:6e02:1313:: with SMTP id g19mr22272693ilr.177.1605782824411;
 Thu, 19 Nov 2020 02:47:04 -0800 (PST)
MIME-Version: 1.0
References: <9b6eefd1-e6f9-ddc2-2eed-6ecba00fb982@redhat.com>
In-Reply-To: <9b6eefd1-e6f9-ddc2-2eed-6ecba00fb982@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 19 Nov 2020 11:47:06 +0100
Message-ID: <CAOi1vP8k1Bsjgh_iQwcAAT7g9cn2Zp9vcJcxf0urEc8LgcEVOw@mail.gmail.com>
Subject: Re: [ceph-users] v15.2.6 Octopus released
To:     David Galloway <dgallowa@redhat.com>
Cc:     ceph-announce@ceph.io, ceph-users <ceph-users@ceph.io>,
        dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        ceph-maintainers@ceph.io
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 19, 2020 at 3:39 AM David Galloway <dgallowa@redhat.com> wrote:
>
> This is the 6th backport release in the Octopus series. This releases
> fixes a security flaw affecting Messenger V2 for Octopus & Nautilus. We
> recommend users to update to this release.
>
> Notable Changes
> ---------------
> * CVE 2020-25660: Fix a regression in Messenger V2 replay attacks

Correction: In Octopus, both Messenger v1 and Messenger v2 are
affected.  The release note will be fixed in [1].

[1] https://github.com/ceph/ceph/pull/38142

Thanks,

                Ilya
