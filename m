Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771FE6A8656
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 17:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCBQZR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Mar 2023 11:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjCBQZP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Mar 2023 11:25:15 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61B036FCC
        for <ceph-devel@vger.kernel.org>; Thu,  2 Mar 2023 08:25:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id f13so69821160edz.6
        for <ceph-devel@vger.kernel.org>; Thu, 02 Mar 2023 08:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677774308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhKIiAmcPhBUSJ5jM/F296GdMRwM+xGlmyeLC0miw18=;
        b=GyySJcfPSO6aApyZdu+FGjSYfFYQnvuHkXSXPPwxZxEIRWtmVEjVyEd4zcoCbQcWmB
         IJs0Q2D2XRw1LCXpWsny9318e5XAbGCqE3+WLnl9i9yFW8vwX00mSzaT3kIO3xdATfqR
         +qIo3b++vYXaOm2HlPRk3LA5LkkZHqeuNBrr4b2JK0b/4LLYezU/1wE1efICAyY/mpp4
         rIaTHA3IDS4qBy/1Fa6BSr3CagmSyIAxPOqG81YE8bA/JOuwJic6K6CuQw9d4SPP7f1U
         U/sRCO+YYYzJjD+AssoevNDQlvFjZehGAz5W3RNFZtbFMEOgzmANSrpSkVye0B/yQEj7
         kVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677774308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhKIiAmcPhBUSJ5jM/F296GdMRwM+xGlmyeLC0miw18=;
        b=YckmY4nIRtDRn8Xu+q6z2NLJeriYtsNaFb9RiCgsRljdX914sPQl4T2RkHfiU0t8IY
         +I06JTnW8ciSwbJ5i5z6+T2/a/IZStnL3q0FAkb589NQ7fmTbU4mY/+a7577SI1yWTAG
         s3Tk0Esb6oVq141+vYep4/kBLvpzCEUl444n12lovBxt/L6smX4QqAgv1gOqPRwP/V8p
         i35fG3zuDAFWPP6idwbVF1pXWLFk32cqmqHfKTmCjL6jgUoSM/DNjOsBY/rxhJrneRX8
         MgAercn/RIH1BTPTKBfVlM/QgPfMzSivjPk0dk5YlqPyAAVxXkikhlb/Sk+8jfV07Ncr
         28gw==
X-Gm-Message-State: AO0yUKXWsf98X4/ytuxgq1IY6oYt1rmAMLgOKWNNkk0ITSwmeZmsSSNA
        1tb8wadjwHHN7Aot8M/x6E092rXDky2WQO49v9I=
X-Google-Smtp-Source: AK7set/Dm5kPRC2kX8F7QUgWcqGZ4UwmAkCLxjT42HI4Nh1BNCRzopGXyv7FKBKv56VrbseB+8+DvZHOA6Xq0oe6QJU=
X-Received: by 2002:a17:906:d1c9:b0:878:b86b:de15 with SMTP id
 bs9-20020a170906d1c900b00878b86bde15mr5415185ejb.11.1677774308018; Thu, 02
 Mar 2023 08:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20230302122559.501627-1-xiubli@redhat.com>
In-Reply-To: <20230302122559.501627-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 2 Mar 2023 17:24:56 +0100
Message-ID: <CAOi1vP_V=ajo6XDNTTRXAmm2S1HP2MLWWJyOZWXJbquNmgyjmw@mail.gmail.com>
Subject: Re: [PATCH v4] ceph: do not print the whole xattr value if it's too long
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 2, 2023 at 1:26=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If the xattr's value size is long enough the kernel will warn and
> then will fail the xfstests test case.
>
> Just print part of the value string if it's too long.
>
> At the same time fix the function name issue in the debug logs.
>
> URL: https://tracker.ceph.com/issues/58404
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V4:
> - fix the function name issue in the debug logs
> - make the logs to be more compact.
>
>  fs/ceph/xattr.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..5ab4aed2eecc 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -561,6 +561,8 @@ static struct ceph_vxattr *ceph_match_vxattr(struct i=
node *inode,
>         return NULL;
>  }
>
> +#define MAX_XATTR_VAL_PRINT_LEN 256
> +
>  static int __set_xattr(struct ceph_inode_info *ci,
>                            const char *name, int name_len,
>                            const char *val, int val_len,
> @@ -623,7 +625,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
>                 xattr->should_free_name =3D update_xattr;
>
>                 ci->i_xattrs.count++;
> -               dout("__set_xattr count=3D%d\n", ci->i_xattrs.count);
> +               dout("%s count=3D%d\n", __func__, ci->i_xattrs.count);
>         } else {
>                 kfree(*newxattr);
>                 *newxattr =3D NULL;
> @@ -651,11 +653,13 @@ static int __set_xattr(struct ceph_inode_info *ci,
>         if (new) {
>                 rb_link_node(&xattr->node, parent, p);
>                 rb_insert_color(&xattr->node, &ci->i_xattrs.index);
> -               dout("__set_xattr_val p=3D%p\n", p);
> +               dout("%s p=3D%p\n", __func__, p);
>         }
>
> -       dout("__set_xattr_val added %llx.%llx xattr %p %.*s=3D%.*s\n",
> -            ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len=
, val);
> +       dout("%s added %llx.%llx xattr %p %.*s=3D%.*s%s\n", __func__,
> +            ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
> +            min(val_len, MAX_XATTR_VAL_PRINT_LEN), val,
> +            val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
>
>         return 0;
>  }
> @@ -681,13 +685,15 @@ static struct ceph_inode_xattr *__get_xattr(struct =
ceph_inode_info *ci,
>                 else if (c > 0)
>                         p =3D &(*p)->rb_right;
>                 else {
> -                       dout("__get_xattr %s: found %.*s\n", name,
> -                            xattr->val_len, xattr->val);
> +                       int len =3D min(xattr->val_len, MAX_XATTR_VAL_PRI=
NT_LEN);
> +
> +                       dout("%s %s: found %.*s%s\n", __func__, name, len=
,
> +                            xattr->val, xattr->val_len > len ? "..." : "=
");
>                         return xattr;
>                 }
>         }
>
> -       dout("__get_xattr %s: not found\n", name);
> +       dout("%s %s: not found\n", __func__, name);
>
>         return NULL;
>  }
> --
> 2.31.1
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
