Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DE1357A11
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Apr 2021 04:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDHCJl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Apr 2021 22:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHCJj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Apr 2021 22:09:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0876FC061760
        for <ceph-devel@vger.kernel.org>; Wed,  7 Apr 2021 19:09:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id o123so679864pfb.4
        for <ceph-devel@vger.kernel.org>; Wed, 07 Apr 2021 19:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XGCTOALcRxE2EoE2IONli5oNfkywThz+9uzbBjTb5Mo=;
        b=b6wzgX3RHKG07Y5ZXSzH0e5zjfOeVsXuPKuvOv+fHr4yxoLWvbWrMQ4JgWaDvfNegj
         k4DnjkZ0tu7qDd4Iye6CugbcAF+NBArAjJFebP/l5FihzRPzlcEVTK6Gb3IXFB9Q6u9J
         aJamIGrxvS9A1vg4jZLHtcBC8+1FNaFZiZkWiDBYD3SdhEjdHBUDVs+/PmMJbTQCDoko
         4WibZgq3f56fehzD+YK5Ybm8bogdGUJdpTr9utMGJGtNCnsk7gNO0JgWJiAIcwzSKDDp
         W7v+Yw0qIMrcknwhussHXwWRnNXffi4NimimDKLFKMH2yqzuuvfxOqk6eFEP0KX0/w6j
         NRtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XGCTOALcRxE2EoE2IONli5oNfkywThz+9uzbBjTb5Mo=;
        b=EnoS4Lcb0kPYajNglgvwUauZsKY/UYTEDJ2dsCDxDuM8ptQFiuv3QcoTfuCT5oRIpo
         ElNBc7mrxFax54jhoWUqk8G6QWwk6wn0YUxaxMOrXALrZ/bVQMoiBRNgfAjIvwzPk4ot
         s+v8vadNBaEvb+IyGoEVq7emqbvBbiAq8gilLSNQFoHXbUVqn5j+HpYLoAiWD29aJZ81
         VpqSWknNm+ufAYpdKDQBjFnpRxMWnT7w7RAlFJ/oOY3BC1vyFBBnTJkVbfHRgvum3+Zs
         BBHAIcogFv+ZZH2wMEGywbhLtJcEZloUAgFYpojGDYb7FLaO0kOqkUah4rSEkxsT5Rgj
         i/Dw==
X-Gm-Message-State: AOAM530i+WqhrIiRPlihzKEyFHhatdKU0oPO9uNp+xtbLmIMldqXbDmn
        5IACtRfnoXr/4lksT7eLX7F0A9NsFy8+ZWqybCLKJfiLMO1s+Q==
X-Google-Smtp-Source: ABdhPJx8m1LFBDwrrgfOZ8Bvf2sAyT3T9u2rraJT1sTvFBV9PaR2eCVRPtwGvPaqjyBXmwf5u29ivU7pbj5tcnQpTzY=
X-Received: by 2002:a62:1557:0:b029:20d:6986:627e with SMTP id
 84-20020a6215570000b029020d6986627emr5417893pfv.21.1617847767234; Wed, 07 Apr
 2021 19:09:27 -0700 (PDT)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 8 Apr 2021 10:09:14 +0800
Message-ID: <CAPy+zYWq6zUq0OV=ob=NnV1h1tUqG9BnQGSsyJ99gDrFCPMFmQ@mail.gmail.com>
Subject: rgw: In a multi-site environment, deleting the key from the bucket
 list operation will cause the object's key to be permanently lost.
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In a multi-site synchronization environment, the bucket full sync
process will send a bucket list request to the remote, but the remote
execution of the bucket list operation is likely to delete the object
key.
for example:
t1 object upload-start [rgw_bucket_dir_entry.exists =3Dfalse] =EF=BC=88put =
obj=EF=BC=89
t2 list bucket opreate start find 'rgw_bucket_dir_entry.exists
=3Dfalse'=EF=BC=8Cand get_obj_state() return noevent. (list bucket)
t3 object upload-end =EF=BC=8C[rgw_bucket_dir_entry.exists =3Dtrue],(put ob=
j)
t4 list bucket remove object key because t2.(list bucket)
I wonder if it is possible to add a timestamp to rgw_bucket_dir_entry,
if you want to delete the key, to determine whether it expires and
delete it.
