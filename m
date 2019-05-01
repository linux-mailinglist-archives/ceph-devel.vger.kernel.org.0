Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF7610A97
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2019 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfEAQHO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 May 2019 12:07:14 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:44597 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfEAQHO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 May 2019 12:07:14 -0400
Received: by mail-oi1-f172.google.com with SMTP id t184so11636964oie.11
        for <ceph-devel@vger.kernel.org>; Wed, 01 May 2019 09:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=YY0kFcoA/WTTdlrjREOeH8laYpG+z+7tpV6b60NsS1A=;
        b=uDFafaJJcY6x+RGQBxoyG0imGIP4DsOsPmnEXmhRC8OeiJ1ISG2f9Jvs/OiJJWe0bl
         rjGdRrI7SmndZtlrjQwg0ZXc8Vyl95EvtuAWcMFIG9ty7IE40XP25qBz/bDyYLs6tmKF
         eJQj28LhWK494HG14rVhhCRNm7crVRKMQI4vGzw1Jla5nukQeuBPzGHHcoGdYUvp4thW
         +izFD2Sl8ksFaDqFVxm2WA/zDdQGd22h8MG2+D8bO/HHSsIV6Ec+sj3TpbXFESNxLS7g
         +tTnMs4x5+wjq+WpBQ2YCCd4e8MC9IJwy4Mk18mejeVz/O2Ny+IjernBfLm0EPEAilz6
         5pRw==
X-Gm-Message-State: APjAAAV0gHVXLPQBHCSzJEjPtppuDpBb1ZundUl2TP6geCrb28k7oIPE
        4TbM3a/5Dui/66sjNJqIDTBl+M/RPdaLpJvsqOQ4XsI=
X-Google-Smtp-Source: APXvYqzF+P56oZ52W5xl/t0VIkEBoXE4LEm7zbuuzq8JzpOF4N3kLXCO4h7OzZqTwkQ0X1HuslyuN092mRq0ML0tCGM=
X-Received: by 2002:aca:f4cf:: with SMTP id s198mr6751750oih.153.1556726833599;
 Wed, 01 May 2019 09:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
In-Reply-To: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
From:   Andrew Schoen <aschoen@redhat.com>
Date:   Wed, 1 May 2019 11:06:37 -0500
Message-ID: <CAEPMp+6-h32Rgz9TskHj7dXDESorZo8O3HQDKHWhJfGWQgoS7A@mail.gmail.com>
Subject: Re: ceph-volume and multi-PV Volume groups
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> I'm aware that one could work around this by creating the LVM setup that I want.
> I think this is a bad approach though since every deployment tool has to
> implement its own LVM handling code. Imho the right place for this is exactly
> ceph-volume.

I've been thinking about porting some of the `batch` lv creation functionality
to the `create` subcommand. I think it'd be nice to be able to pass a
raw device to any of the
available flags in `create` and if that device has already been used
as a pv and a vg exists then
that vg would be reused, otherwise a new pv and/or vg would be
created. This is beneficial because it
gives the control that users seem to wish `batch` had, like `create`
already does. Would that solve this problem for you?

I'd be hesitant to change `batch` here. Originally we went down the
path of having one vg per pv for
db/wal but it added tons of complexity to the code to manage that.
With fairly simple workarounds existing for
`batch` plus the availability of the `create` subcommand we felt it
wasn't worth the potential maintenance and
complexity burden to put this sort of functionality in `batch`.

Best,
Andrew
