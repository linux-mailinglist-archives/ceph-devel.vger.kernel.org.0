Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33302797A33
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Sep 2023 19:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbjIGRdV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Sep 2023 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245219AbjIGRdN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Sep 2023 13:33:13 -0400
X-Greylist: delayed 88458 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 10:32:45 PDT
Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [IPv6:2001:7c0:2041:24::a:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6567171C
        for <ceph-devel@vger.kernel.org>; Thu,  7 Sep 2023 10:32:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 23B5860F05;
        Thu,  7 Sep 2023 13:57:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
         h=content-transfer-encoding:content-type:content-type
        :in-reply-to:from:from:references:content-language:subject
        :subject:user-agent:mime-version:date:date:message-id; s=dkim;
         i=@sec.uni-stuttgart.de; t=1694087849; x=1695826650; bh=/WxOliv
        F7mVde/IqRUEmyC2/Rgqib3apEEff44qzMno=; b=NzuvbZv3NRlRactdVwYuF7/
        LD3X5KV6q9QtnE3RAB7I1r0NCqX6g5nx+xMYiME8SQLYYlgHwn8lQPV7Kd8rdFRJ
        lR/8OaAT0vt2+csGw8wwiYXusoZVCstDE6cEOfUzJhCHOH9fb4MyE54APmLk1SRU
        Xpz+vIpov/XmnTcgGt+4TRssmgego2K8pdJilbjjFYR4FRQXhVC7YkhC+jZiBeqD
        RJBLY/zhZ9B+EdMz/7HGNo+BobmZEtlADtV8SjMZL1f5uVyaBz7Jkrda09RCxJL+
        5PXhmDIBrSUxDEs9MZvhDuQOI84gHFoFse3jtvmcWCQBcKIG95hW+ySJ1hytbUw=
        =
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id TCK_zXAtnvnR; Thu,  7 Sep 2023 13:57:29 +0200 (CEST)
Received: from authenticated client
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Message-ID: <6dc123eb-7251-03a6-87ce-abe11925e2e3@sec.uni-stuttgart.de>
Date:   Thu, 7 Sep 2023 13:57:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being
 unlinked
Content-Language: en-US
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org
References: <20220804080624.14768-1-xiubli@redhat.com>
 <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
 <3f6b622d-8513-f289-5146-546c1f747e10@redhat.com>
From:   Sebastian Hasler <sebastian.hasler@sec.uni-stuttgart.de>
In-Reply-To: <3f6b622d-8513-f289-5146-546c1f747e10@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 07/09/2023 04:05, Xiubo Li wrote:
>
> int linkat(int olddirfd, const char *oldpath, int newdirfd, const char 
> *newpath, int flags);
>
> BTW, for "an open file descripter", do you mean "olddirfd" ? Because 
> "olddirfd" is a dir's open file descripter, how is that possible it 
> can become linked again ?

Yes, I mean olddirfd, and the manual says: "If oldpath is an empty 
string, create a link to the file referenced by olddirfd".

-- 
Sebastian Hasler, M.Sc.
Institute of Information Security - SEC
University of Stuttgart
Universitätsstraße 38
D-70569 Stuttgart
Germany
https://sec.uni-stuttgart.de
Phone: +49 (0) 711 685 88208

