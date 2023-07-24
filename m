Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13DA75F495
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jul 2023 13:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjGXLMh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jul 2023 07:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjGXLMf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jul 2023 07:12:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66A41B3;
        Mon, 24 Jul 2023 04:12:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-992acf67388so629928066b.1;
        Mon, 24 Jul 2023 04:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690197144; x=1690801944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWljH0YhdNKF92EW5dPIKEh8+4/5En6qp1zD5+47jbA=;
        b=eX6MfIwkTWul6mrm69EN3+snhsxnz7kHl7kbt6ACL9yp82xYUyobelgSNkycuMD1mf
         UnFZtS0xl0jBQWHAsQ81XHJwEh6NBCnOKwmJ843JSsnDiLJhDXn8874JZwBJx0vGfVjE
         s1zSeHpgiPVExZ+F5LDPxW298ox0JG7XHD+kHQXa8j9Is8LadNz5LFmvkK5JALB78NRt
         P5W/rw/AbuKwvjvpYJBkcEj9qMwGZ5ddHZiWdK1b92A7x40mg+cQFrjxp07rKPs1mxME
         tb1UiosFWsQepNMctmeExnRoAAozwrquRx9JJg6/A5jqR9N14MScP2FkipVt8rdbBs9z
         N4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690197144; x=1690801944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sWljH0YhdNKF92EW5dPIKEh8+4/5En6qp1zD5+47jbA=;
        b=EXC4iDLlR2qB5aHIJzSyBmtlgh9qVOEYeyI4siuSLcI1YluFWGwA4A5G3KoNgeJjjs
         fAifSzeuag6C+M9Jl01g4U3ZrZipGZirtBvSQoeJlthPaHnTMX4wplklH0hXf30bNTVG
         bTvtEubBqSHkHhSHiTEpm6fkC+Wo10gcDS4sumVREKE+ywxmBsRHHtoJFIw9aO4OHXDV
         bt8nFrAl6JmBXo7DVPYdD7ibWmrOyLB3W6D5HiKwjiK9Wx+Ytb0Zkz36N5TIXKxl5DGT
         iTwbBuPmRQwb+ps6z8lesWggwtHQG173XE+D0WIWgAzU2j0JEjZoaWbNr+DV1DfChdnY
         zcHg==
X-Gm-Message-State: ABy/qLaQxoBThITwFeJboPNNF8KPuEMITySK++dHH7+Ssf79eLFxqpvq
        hFrp2itSbA/biGLCHXoWzCL5KX/45hqsgYH/LKc=
X-Google-Smtp-Source: APBJJlGaX5TeKV9aBL/fmLyUPsaEDOkX1Z5w62I+N5lgTtWk/KQga/J9FYXojVHjcrdx66LKjlrPBPo+y9vvR+yW9VE=
X-Received: by 2002:a17:906:5190:b0:991:37d2:c9ea with SMTP id
 y16-20020a170906519000b0099137d2c9eamr9612878ejk.6.1690197143854; Mon, 24 Jul
 2023 04:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230724084214.321005-1-xiubli@redhat.com>
In-Reply-To: <20230724084214.321005-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Jul 2023 13:12:11 +0200
Message-ID: <CAOi1vP9Yygpavo8fS=Tz8YGeQJ7Wmieo=14+HS20+MSMErb79A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: defer stopping the mdsc delayed_work
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 24, 2023 at 10:44=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Flushing the dirty buffer may take a long time if the Rados is
> overloaded or if there is network issue. So we should ping the
> MDSs periodically to keep alive, else the MDS will blocklist
> the kclient.
>
> Cc: stable@vger.kernel.org

Hi Xiubo,

The stable tag doesn't make sense here as this commit enhances commit
2789c08342f7 ("ceph: drop the messages from MDS when unmounting") which
isn't upstream.  It should probably just be folded there.

Thanks,

                Ilya
