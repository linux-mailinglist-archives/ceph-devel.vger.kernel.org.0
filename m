Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D758F6ECB93
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Apr 2023 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDXLtp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Apr 2023 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDXLto (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Apr 2023 07:49:44 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5DA421A
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 04:49:37 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-4403aef7f1fso1522907e0c.2
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 04:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682336976; x=1684928976;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VNyu6CeR1v7eOKdhR+7FYRtqpjhTov8RoGdraKq+664=;
        b=AleCIb2lkLWG994h4VHcVE4IPdacmWZx6EmDsXSDjzsckfsJcpAwRqXK9ZmbiE/hYP
         2l3JpRq4iFMPh2hkF5UXlGvx5DcC52xJ/r2J8aEfDKT+r0oqMnbkQFHKwj7/EiY3E0MG
         n29+b2WQ7TQ/VwsiSrAIvkHlrTJDIaxWsji4l4uXkKHRzIoCSePMaaAb0au3tfRAytUp
         KhLqZHKbnrJSw8hmlpwC+FXD+VxP96CBQXJJkYZol1CX6NuKBnIu3MQoDFE3rfHGNrQh
         ZjUHs0EBvq9l9NtlbirjvrFGvOPQXBa2QeCCfaMnuQIUkIB6p9xoorxgYv5JQLx+cnuo
         k7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682336976; x=1684928976;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNyu6CeR1v7eOKdhR+7FYRtqpjhTov8RoGdraKq+664=;
        b=SBCfLn8AJCMkyMbH5htV2ItPiXu7a2faJl4e68SXaX8PUR+P20wFByhlZ/wG6lmb3j
         oo4wBJyF38vJieE/lv0Ul9G/dIVVtjizIx2TZ+abPuOF0X+WeGYUofeeqNCz1Ao5iFMm
         p5zALKQAZHE5MdOHHfXHVtU3XElBmO97Tp194iPxqBC3yPdQsv/LNOKGG06ZFu+TCO/W
         Rhcn+/WLqOkWf5QSApQ8VhoQAJbZIszs+BRjaRuIYIM1pZkYQOpUUXSuojpjR32VZZ1k
         +re+QOd6U/SpdJakFp+wQygXucLF7f6hZaIIVnNniJj8PdvdHnkUPFZX+6a7c567xd5x
         ldSA==
X-Gm-Message-State: AAQBX9fPHeAu1MdIvusC5lX2ne55FqvZSrRK8rvvT1VgEHHTU+eEepGc
        XgQT1OdCIy3wkgC5+IYovcQwcyFwIHKX+9xQvqZ2hyaMcR0=
X-Google-Smtp-Source: AKy350ZzT0UkGd1Scz2iVcw03rhVSh0l6bAtl6qbk0RVGFATGq02c5yW+CHgutlZAgq4DG0VLJT3Qqz5UblY69HKTGc=
X-Received: by 2002:a1f:3dc4:0:b0:3ea:7af1:9ea4 with SMTP id
 k187-20020a1f3dc4000000b003ea7af19ea4mr2806355vka.12.1682336976438; Mon, 24
 Apr 2023 04:49:36 -0700 (PDT)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Mon, 24 Apr 2023 19:49:26 +0800
Message-ID: <CAPy+zYVpqE6T0V=7Sq4TdaziF+Azgph00FyJ8W+tARBb57Vo0A@mail.gmail.com>
Subject: =?UTF-8?Q?How_to_control_omap_capacity=EF=BC=9F?=
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I have two osds. these  osd are used to rgw index pool. After a lot of
stress tests, these two osds were written to 99.90%. The full ratio
(95%) did not take effect? I don't know much. Could it be that if the
osd of omap is fully stored, it cannot be limited by the full ratio?
ALSO I use ceph-bluestore-tool to expand it . Before I add a partition
. But i failed, I dont know why.
