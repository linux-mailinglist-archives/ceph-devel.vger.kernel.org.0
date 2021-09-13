Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B10A40847E
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 08:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbhIMGJ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 02:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbhIMGJz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Sep 2021 02:09:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CEC061574
        for <ceph-devel@vger.kernel.org>; Sun, 12 Sep 2021 23:08:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id g14so7809553pfm.1
        for <ceph-devel@vger.kernel.org>; Sun, 12 Sep 2021 23:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=iM+1J6+s+dcHUDFBIJTQUxJDphCaKegd9tpT02ez0YI=;
        b=WlzUeCvk0lVmH3B8C0OHWkHgd2nUy2HDbqGJvZML3YRHfa92auROYqUmJyPNvWt4PQ
         bIvrYSkUToSvZP92BPaAnT2v5i9kPw2oXckuD/FkgeRgwWHJ1AD6N40VckMCL+EgXOrP
         lrNPfeL6/kVk7dYyhfO2TLSAXCok+0Hn/Li4JrUaciUZvBHiJMlu3AArosx6qOjDgK55
         I2ltzyHBfCk3/tCPVhFAv7XV54/ytI+IQ4uOLm0OjcXWzlt4Q1Ps0NRIOQjKdlx2V/WB
         dg/IPMGHWjAzMIrC+JsN9m3A+BXgs84gvSdUVl81TLo4Wj/G3WMuwAGizQQ36zw9nIk6
         KHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=iM+1J6+s+dcHUDFBIJTQUxJDphCaKegd9tpT02ez0YI=;
        b=4rfNHP5yqWiB/3FCywobhzfiZ1lwLeMy6oRLgklbcMf57gmSDjuIA6WALMVZ7SXi7h
         4mpmIOBrjUdMWxjsRro9rdEe/8XI0AAckdb9h0ICbS4CUYKQ0SlQNP8rqeKUEIxw/shG
         14CKzTWepR5lvW7MJIOTSryN90enbHrKTvHOdQXh4aL/1jyNvO3dxs9L1oaSOHsvy3h9
         iJlSdcs+CcEJK7gYjGNVnk4MOAJwo+3jhjnOjKy4VjfQIfxwhz2U8veLo0/E5hkh1JGG
         ZR6fLJGKmteAbZkmRLe13i/9viexmXTtA5SdW/sgiNSSQHV8TIEHs7VVI6mutLWWGUfP
         1SIQ==
X-Gm-Message-State: AOAM530eqMhJCrga43psBmWaPDPp4mc9wHFA4byZavvWg93/mXWicyov
        9tmhPNeTdhYTQtQaMfziznoNMitVvcyW3o6VRjU=
X-Google-Smtp-Source: ABdhPJyuqcA02krj4yHDkL0pDXln1EOizYJKzf/EggTX/uIE+if5uHIR3+HOfmQrP2eUkYulmRzPKq/4+SPM+J0XoS4=
X-Received: by 2002:a63:b218:: with SMTP id x24mr9693454pge.335.1631513319813;
 Sun, 12 Sep 2021 23:08:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:1a46:0:0:0:0 with HTTP; Sun, 12 Sep 2021 23:08:37
 -0700 (PDT)
Reply-To: michaelrachid7@gmail.com
From:   Michael Rachid <debbygerald.66@gmail.com>
Date:   Mon, 13 Sep 2021 07:08:37 +0100
Message-ID: <CAPkx40Ok0mTRoy+iENqPBjy0iT4MOtc6+nfK55GbGUbUG9LA8w@mail.gmail.com>
Subject: =?UTF-8?B?UHJvcG9zYWwv0J/RgNC10LTQu9C+0LbQtdC90LjQtSBQcmVkbG96aGVuaXll?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

UHJvcG9zYWwv0J/RgNC10LTQu9C+0LbQtdC90LjQtSBQcmVkbG96aGVuaXllDQoNCg0KDQoNCtCU
0L7RgNC+0LPQvtC5INC00YDRg9CzLA0KDQrQryDQv9C40YjRgywg0YfRgtC+0LHRiyDQv9GA0L7Q
uNC90YTQvtGA0LzQuNGA0L7QstCw0YLRjCDQstCw0YEg0L4g0LrQvtC80LzQtdGA0YfQtdGB0LrQ
vtC8INC/0YDQtdC00LvQvtC20LXQvdC40LgsINC60L7RgtC+0YDQvtC1DQrRjyDRhdC+0YLQtdC7
INCx0Ysg0L7QsdGB0YPQtNC40YLRjCDRgSDQstCw0LzQuC4NCtCg0LXRh9GMINC40LTQtdGCINC+
INC/0Y/RgtC40LTQtdGB0Y/RgtC4INC80LjQu9C70LjQvtC90LDRhSDQtNC+0LvQu9Cw0YDQvtCy
LiDQkdGD0LTRjNGC0LUg0YPQstC10YDQtdC90YssINGH0YLQviDQstGB0LUNCtC30LDQutC+0L3Q
vdC+INC4INCx0LXQt9C+0L/QsNGB0L3Qvi4NCtCf0L7QttCw0LvRg9C50YHRgtCwLCDRg9C60LDQ
ttC40YLQtSDRgdCy0L7QuSDQuNC90YLQtdGA0LXRgS4NCg0K0JzQsNC50LrQuyDQoNCw0YjQuNC0
Lg0KDQpEb3JvZ295IGRydWcsDQoNCllBIHBpc2h1LCBjaHRvYnkgcHJvaW5mb3JtaXJvdmF0JyB2
YXMgbyBrb21tZXJjaGVza29tIHByZWRsb3poZW5paSwNCmtvdG9yb3llIHlhIGtob3RlbCBieSBv
YnN1ZGl0JyBzIHZhbWkuDQpSZWNoJyBpZGV0IG8gcHlhdGlkZXN5YXRpIG1pbGxpb25ha2ggZG9s
bGFyb3YuIEJ1ZCd0ZSB1dmVyZW55LCBjaHRvDQp2c2UgemFrb25ubyBpIGJlem9wYXNuby4NClBv
emhhbHV5c3RhLCB1a2F6aGl0ZSBzdm95IGludGVyZXMuDQoNCk1heWtsIFJhc2hpZC4NCg0KDQoN
CkRlYXIgZnJpZW5kLA0KDQpJIHdyaXRlIHRvIGluZm9ybSB5b3UgYWJvdXQgYSBidXNpbmVzcyBw
cm9wb3NhbCBJIGhhdmUgd2hpY2ggSSB3b3VsZA0KbGlrZSB0byBoYW5kbGUgd2l0aCB5b3UuDQpG
aWZ0eSBtaWxsaW9uIGRvbGxhcnMgaXMgaW52b2x2ZWQuIEJlIHJlc3QgYXNzdXJlZCB0aGF0IGV2
ZXJ5dGhpbmcgaXMNCmxlZ2FsIGFuZCByaXNrIGZyZWUuDQpLaW5kbHkgaW5kaWNhdGUgeW91ciBp
bnRlcmVzdC4NCg0KTWljaGFlbCBSYWNoaWQuDQo=
