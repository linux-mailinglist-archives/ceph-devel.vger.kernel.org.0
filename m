Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0352A177BCF
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 17:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgCCQYE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Mar 2020 11:24:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49075 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729508AbgCCQYE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Mar 2020 11:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17eCclzoCj2Z2qW8lCyI2MfSVWymDq79bmI+rkb67kE=;
        b=b3fQ9qW6gcSM7A3zARRNLm6DnOVPf6DALZD9PSbrmUbRBH2vS5Zie/mjB4U+6+BxkCRnPw
        H+LQudJ5mHFqxScaBnkS+FwsWRwg/aQjDmG7OwgX5+Udu11eSf9C7pYTqMYoLF8Hy2WO/B
        c3FoaSjA0KRV4o/ysqj+Vo1ZwTrWK+g=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-QcWU_C7GOfG3ynXmoN8thg-1; Tue, 03 Mar 2020 11:24:02 -0500
X-MC-Unique: QcWU_C7GOfG3ynXmoN8thg-1
Received: by mail-qk1-f198.google.com with SMTP id z124so2475871qkd.20
        for <ceph-devel@vger.kernel.org>; Tue, 03 Mar 2020 08:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=17eCclzoCj2Z2qW8lCyI2MfSVWymDq79bmI+rkb67kE=;
        b=Tsk094i/aSN+NNGSOxyiG/C2AWsmFIY5CQGlR6BOxdckaZCR9y+KePUNAx1uzEBHO4
         Dse6y6gBkvDzd0PR11rXIrndpOGOkp5STAg50/du15AGICoI6hquUcMEjJB7dpCoxN8J
         ZJFkPrKXe94rCJCKEXpfvm/oCAoEWPw2a97bcVvKWQWCbjJq8hUHPr9eHda/pWEQX8hK
         X02487G+kNrn1Gks/6EVxC2t6s7ohvsjafS1K/YxJdsgFeYqhXA3je7YeKVAhcKgw66T
         3oJb9NjD/4VIYKGImZOMFHSSPCZ7SARp1dd8x8bKY97DlVkmB2uA9TwSCBL77xWi0tw2
         cnqw==
X-Gm-Message-State: ANhLgQ3xjw71kVndvitGeXQdMKSdHoyq+5elT2EeJskr+zQXGsKAjUrw
        t25FI5Zs6kki/P+RdbBoUy7jisK+wT/XJYxcgayC4PCTwEWc//Q53TZrRU6wY4Svpq+TOVI5COT
        PZabzTxx5ylr5yXgHMkpPlHAYXrWxTcmDoOJTLA==
X-Received: by 2002:a05:620a:13ca:: with SMTP id g10mr4613757qkl.385.1583252641855;
        Tue, 03 Mar 2020 08:24:01 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsbNLZTwlBQclTWt58MR1TpByVTneBNk3WT+59x+ehMcCOO5dlMFtk3f7vZdHiGUdVz8v6dF0WlDgQIoig/8Ro=
X-Received: by 2002:a05:620a:13ca:: with SMTP id g10mr4613728qkl.385.1583252641450;
 Tue, 03 Mar 2020 08:24:01 -0800 (PST)
MIME-Version: 1.0
References: <56829C2A36C2E542B0CCB9854828E4D8562BAEEB@CDSMSX102.ccr.corp.intel.com>
In-Reply-To: <56829C2A36C2E542B0CCB9854828E4D8562BAEEB@CDSMSX102.ccr.corp.intel.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 3 Mar 2020 08:23:50 -0800
Message-ID: <CAJ4mKGZR2Vrbc=OhR-i3bo7US544fRQ+2=W92JdqCsYED_oAWg@mail.gmail.com>
Subject: Re: question for ceph study
To:     "Chen, Haochuan Z" <haochuan.z.chen@intel.com>
Cc:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's just an arbitrary value to try and identify the store is really
there. I *think* it's mostly about guaranteeing that the monitor store
has been completely set up (ie, the store is fully created and you can
use it), but I may be forgetting something.

But it's of very little importance in the ordinary course of events.
-Greg

On Tue, Mar 3, 2020 at 8:20 AM Chen, Haochuan Z
<haochuan.z.chen@intel.com> wrote:
>
> Hi
>
>
>
> I am a rookie, one question. what's magic in monitor data? What=E2=80=99s=
 the usage of magic?
>
>
>
> Thanks
>
>
>
> Martin, Chen
>
> IOTG, Software Engineer
>
> 021-61164330
>
>
>
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io

