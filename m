Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE7A93D2
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2019 22:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfIDUhu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 4 Sep 2019 16:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIDUhu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 16:37:50 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EA2DFA289
        for <ceph-devel@vger.kernel.org>; Wed,  4 Sep 2019 20:37:50 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id v143so10225713qka.21
        for <ceph-devel@vger.kernel.org>; Wed, 04 Sep 2019 13:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v2yt1mIdwdMX1rBtdorcYKWcAjwxoJ7uDsL27X+/of8=;
        b=HFXRXCM0ZE7r7RzAPgR298Lj27nGCutfkEqnTBAeSIcfe4SpaizNXxk6B1W676Cs2Z
         +GgSbxoZp0njvCVfi4KxjeGdbG3wpY/J2+TwvFe3S6IqfxqklVhva2CHjCyHIjMmGOC+
         JKafOcGmx1dGNsXjfTMmSnpuvQH3/j+6v5HjbE6nCdlnOMh4epAYt6ryF+RFRocPIY2Z
         Z743OTG/EKeDHs83eXsH5x4pzzDpeLF3YoYe9ylXDxNcUBVypb0QMpT3mZpqJiOKihmd
         kR8R9xjmbbGeHglDflw2UXyx02lCddD179Ta+CFWSUha3wbD1ZEy7GEwbsC0shOEsB+c
         Pp0g==
X-Gm-Message-State: APjAAAW/0qRnExnFs3J2nNE0wBVNoIIx4wJfaXcfx+My3+ytPFwa1puQ
        lnpGCNQ7P79UN8QoMQXaRcoOVlx1VsAncb2YVU9yQQm5n0P6sgaRvJwXvWMKXmt0S+Yvr46JGFX
        TNtKPJZqdWbsMx8ukP7fqduKaOdNzYbus9twyrw==
X-Received: by 2002:ad4:5610:: with SMTP id ca16mr12518300qvb.199.1567629469342;
        Wed, 04 Sep 2019 13:37:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySI2RCuRsJQxg30mgAd2tl3fSoIpbYqFMiNr6jP6v7DkSvfMdBfW0mVN2yMUIcoafjilkFcKJizoqv9EJ2XFw=
X-Received: by 2002:ad4:5610:: with SMTP id ca16mr12518294qvb.199.1567629469036;
 Wed, 04 Sep 2019 13:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
In-Reply-To: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Wed, 4 Sep 2019 16:37:37 -0400
Message-ID: <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com>
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Paul Emmerich <paul.emmerich@croit.io>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 4, 2019 at 4:01 PM Paul Emmerich <paul.emmerich@croit.io> wrote:
>
> Hi,
>
> see https://tracker.ceph.com/issues/41660
>
> ceph-volume lvm activate --all fails on the second OSD when stderr is
> not a terminal.
> Reproducible on different servers, so there's nothing weird about a
> particular disk.
>
> Any idea where/how this is happening?

That looks very odd, haven't seen it other than a unit test we have
that fails in some machines. I was just investigating that today.

Is it possible that the locale is set to something that is not
en_US.UTF-8 ? I was able to replicate some failures with LC_ALL=C

Another thing I would try is to enable debug (or show/paste the
traceback) so that tracebacks are immediately available in the output:

CEPH_VOLUME_DEBUG=1 ceph-volume lvm activate --all

I'll follow up in the tracker ticket
>
> This makes 14.2.3 unusable for us as we need to re-activate all OSDs
> after reboots because we don't have a persistent system disk.
>
>
> Paul
>
> --
> Paul Emmerich
>
> Looking for help with your Ceph cluster? Contact us at https://croit.io
>
> croit GmbH
> Freseniusstr. 31h
> 81247 München
> www.croit.io
> Tel: +49 89 1896585 90
