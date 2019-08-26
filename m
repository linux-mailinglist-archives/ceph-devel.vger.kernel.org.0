Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E219C8F1
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 08:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfHZGJK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Aug 2019 02:09:10 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42166 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGJJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 26 Aug 2019 02:09:09 -0400
Received: by mail-oi1-f178.google.com with SMTP id o6so11245022oic.9
        for <ceph-devel@vger.kernel.org>; Sun, 25 Aug 2019 23:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2zGH/pvTG8dXTFD+3z2rScG9H0t2WYQL0L/GgWmXXUk=;
        b=d4OwKn7fB22YiucDIffS3Q2Hzk2aFlK8atcm3+tFcP5hjFFVelrUcZp7Uo5GBF/R2F
         32KleWeSSZBpuvnJBHq110lx9J640kbA2dCrY+ZRsFab86ANWfPiYsAN4jR4gAFdH5rm
         QD9iXfhNXd5Oc/zvTLSppJByyiTUNl7r1tS4bqUyxRW/ej6GCAIALJ+4S2lkFvdR++Iu
         4bXRYPGlVV7b5CakjU0lk0vuvv5MAOP3aD8UuH47SG5QLhoilipJdXneta99ZfyxVwU7
         SE+6weywzkw/FTMN63NDuOIwDGoCWGx/K28WtV9i63C2T1Vel51HKbdPV1grZqh1jSBh
         rxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2zGH/pvTG8dXTFD+3z2rScG9H0t2WYQL0L/GgWmXXUk=;
        b=qD5kgEIBM5FlOuhq//VIQq+BQRTcluY0EoFn1jJtUGRFm4z2b7UQd4EjTens4he2ju
         UHHY5DParsj7FR8QNDMmAVtOC8aLiwBCyhP1aJblQl59XMCDH9SlMwunbZAAUmcB1BhL
         SrVyGNAoUmpdem1uwr74+v33aYwgf4cYDDMiAFKPwmHElGMzpaZkDyIBe9WwFzRWGRxU
         oXNV6MAYFM93lad4dekIjpbaL9VElUtqX31k4qFgu+PP4OOBYLnY11uRiusVjdxgz/0G
         axfG/z8gfp+aq7q2AIOyiZDFHmvanjK6tYGvXrHL7dYlkBhYh28OHJ3J1iFORS2uWj+J
         BaCw==
X-Gm-Message-State: APjAAAV8jwUy5+e5h5+ridlcNV1+LG/bYuf/oGexugiSL4gTFSJNrOAk
        SMli3+VfDDyzNcaSLXJh+V2jouWXdzpNLM+nuKJFfsCQPLg=
X-Google-Smtp-Source: APXvYqw4WsTNqcCDoCAUj+olaw5s2u2hWXF3acedIXoUdv1z1U3nm6lLkWTNv7fOh6akEIdF6hhyt3TkfwGA2GvvZQs=
X-Received: by 2002:aca:6701:: with SMTP id z1mr10534829oix.164.1566799748166;
 Sun, 25 Aug 2019 23:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org> <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
 <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
 <CAJE9aOMNvOmLc9=7LLCfZTUgiyjM20vpiE8a8v9iM8CyBVJE1g@mail.gmail.com>
 <orblwk9xwp.fsf@lxoliva.fsfla.org> <CAJE9aONvV+mfCDWpFdE_cZBbaa91wS2ECXoYjqQ3i1h4HQmZrg@mail.gmail.com>
 <ory2zn8wow.fsf@lxoliva.fsfla.org> <orr25al2fq.fsf@lxoliva.fsfla.org>
In-Reply-To: <orr25al2fq.fsf@lxoliva.fsfla.org>
From:   kefu chai <tchaikov@gmail.com>
Date:   Mon, 26 Aug 2019 14:08:56 +0800
Message-ID: <CAJE9aOPs5Kfkk=ewF9FAXvR1gN+EFUFWuatDAhdpskthn3r46w@mail.gmail.com>
Subject: Re: fix for hidden corei7 requirement in binary packages
To:     Alexandre Oliva <oliva@gnu.org>
Cc:     Brad Hubbard <bhubbard@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Aug 25, 2019 at 4:43 AM Alexandre Oliva <oliva@gnu.org> wrote:
>
> On Aug 20, 2019, Alexandre Oliva <oliva@gnu.org> wrote:
>
> >> if you are able to pinpoint an FTBFS issue or bug while using Ceph on
> >> 32 bit platforms. i can take a look at it.
>
> > Oh, thanks, I didn't mean to burden anyone with that, it's just
> > something that I care about and would be happy to undertake myself.  I
> > was just surprised that there weren't i686 ceph packages in Fedora 30,
> > and found comments in the spec file suggesting it didn't work, but I
> > didn't look into why yet.
>
> Here's the patch I used to disable spdk in my rebuilds of the Fedora 30
> packages.
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 3b95cc231d2c..ba4fc8506651 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -267,7 +267,7 @@ if(WITH_BLUESTORE)
>    endif()
>  endif()
>
> -if(CMAKE_SYSTEM_PROCESSOR MATCHES "i386|i686|amd64|x86_64|AMD64|aarch64"=
)
> +if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
>    option(WITH_SPDK "Enable SPDK" ON)
>  else()
>    option(WITH_SPDK "Enable SPDK" OFF)

SPDK is disabled by default now, see https://github.com/ceph/ceph/pull/2972=
8

>
> With the following additional tweaks, I could even build 32-bit x86
> packages.  The problems seem to be all related with int types.
>
> For example, this one fixes an assumption that size_t and unsigned are
> not the same type:
>
> diff --git a/src/include/buffer.h b/src/include/buffer.h
> index b8c78210eae0..8e010a150224 100644
> --- a/src/include/buffer.h
> +++ b/src/include/buffer.h
> @@ -737,7 +737,7 @@ inline namespace v14_2_0 {
>
>        void advance(int o) =3D delete;
>        void advance(unsigned o);
> -      void advance(size_t o) { advance(static_cast<unsigned>(o)); }
> +      void advance(unsigned long o) { advance(static_cast<unsigned>(o));=
 }

this function has been removed in a9f8b1a6092a923cae74221d0f1120d106d3cb8f

>        void seek(unsigned o);
>        char operator*() const;
>        iterator_impl& operator++();
>
> This one was the simplest fix I could find to address problems in other
> overloads that did not expect unsigned, only int64_t and uint64_t.
> Though I'm not sure this change gets to external representations, I
> figured it made sense to settle on a well-defined width instead of
> letting it vary across platforms, and to go with the width used in the
> prevalent, working platforms:
>
> diff --git a/src/common/config_values.h b/src/common/config_values.h
> index ab52060e4629..17eb11d0329d 100644
> --- a/src/common/config_values.h
> +++ b/src/common/config_values.h
> @@ -50,7 +50,7 @@ public:
>  #define OPTION_OPT_U32(name) uint64_t name;
>  #define OPTION_OPT_U64(name) uint64_t name;
>  #define OPTION_OPT_UUID(name) uuid_d name;
> -#define OPTION_OPT_SIZE(name) size_t name;
> +#define OPTION_OPT_SIZE(name) uint64_t name;
>  #define OPTION(name, ty)       \
>    public:                      \
>      OPTION_##ty(name)
>
> This is probably the only fallout from the above:

the very same patch was applied in 58b0d514a67ce4f5c115f0f5451d1ac939b3702b

>
> diff --git a/src/osd/PrimaryLogPG.cc b/src/osd/PrimaryLogPG.cc
> index 19bd1a3efd5d..0dcf50ca10cb 100644
> --- a/src/osd/PrimaryLogPG.cc
> +++ b/src/osd/PrimaryLogPG.cc
> @@ -1628,7 +1628,7 @@ void PrimaryLogPG::calc_trim_to()
>        limit !=3D pg_trim_to &&
>        pg_log.get_log().approx_size() > target) {
>      size_t num_to_trim =3D std::min(pg_log.get_log().approx_size() - tar=
get,
> -                             cct->_conf->osd_pg_log_trim_max);
> +                                 size_t(cct->_conf->osd_pg_log_trim_max)=
);
>      if (num_to_trim < cct->_conf->osd_pg_log_trim_min &&
>          cct->_conf->osd_pg_log_trim_max >=3D cct->_conf->osd_pg_log_trim=
_min) {
>        return;

i think it's okay now. as OPTION_OPT_U32 is now defined as a uint64_t,
and approx_size() returns uint64_t as well.

>
> encode/decode don't handle long at all, they deal with u?int{32,64}_t
> and uint64_t.  When int64_t happens to be int or long, this works, but
> when int64_t is long long, then long ends up uncovered:
>
> diff --git a/src/test/bufferlist.cc b/src/test/bufferlist.cc
> index 8a5bc65d31da..adcdcf3b7b68 100644
> --- a/src/test/bufferlist.cc
> +++ b/src/test/bufferlist.cc
> @@ -837,7 +837,7 @@ TEST(BufferListIterator, iterate_with_empties) {
>    EXPECT_EQ(bl.length(), 0u);
>    EXPECT_EQ(bl.get_num_buffers(), 1u);
>
> -  encode(42l, bl);
> +  encode(int64_t(42l), bl);
>    EXPECT_EQ(bl.get_num_buffers(), 2u);
>
>    bl.push_back(ceph::buffer::create(0));
> @@ -853,11 +853,11 @@ TEST(BufferListIterator, iterate_with_empties) {
>      bl.append(bl_with_empty_ptr);
>    }
>
> -  encode(24l, bl);
> +  encode(int64_t(24l), bl);
>    EXPECT_EQ(bl.get_num_buffers(), 5u);
>
>    auto i =3D bl.cbegin();
> -  long val;
> +  int64_t val;
>    decode(val, i);
>    EXPECT_EQ(val, 42l);
>
> @@ -865,7 +865,7 @@ TEST(BufferListIterator, iterate_with_empties) {
>    EXPECT_EQ(val, 24l);
>
>    val =3D 0;
> -  i.seek(sizeof(long));
> +  i.seek(sizeof(val));
>    decode(val, i);
>    EXPECT_EQ(val, 24l);
>    EXPECT_TRUE(i =3D=3D bl.end());
> @@ -2665,7 +2665,7 @@ TEST(BufferList, InternalCarriage) {
>    ceph::bufferlist bl;
>    EXPECT_EQ(bl.get_num_buffers(), 0u);
>
> -  encode(42l, bl);
> +  encode(int64_t(42l), bl);
>    EXPECT_EQ(bl.get_num_buffers(), 1u);
>
>    {
> @@ -2678,7 +2678,7 @@ TEST(BufferList, InternalCarriage) {
>      EXPECT_EQ(bl.get_num_buffers(), 2u);
>    }
>
> -  encode(24l, bl);
> +  encode(int64_t(24l), bl);
>    EXPECT_EQ(bl.get_num_buffers(), 3u);
>  }
>
> @@ -2690,7 +2690,7 @@ TEST(BufferList, ContiguousAppender) {
>    {
>      auto ap =3D bl.get_contiguous_appender(100);
>
> -    denc(42l, ap);
> +    denc(int64_t(42l), ap);
>      EXPECT_EQ(bl.get_num_buffers(), 1u);
>
>      // append bufferlist with single ptr inside. This should
> @@ -2707,11 +2707,11 @@ TEST(BufferList, ContiguousAppender) {
>        EXPECT_EQ(bl.get_num_buffers(), 3u);
>      }
>
> -    denc(24l, ap);
> +    denc(int64_t(24l), ap);
>      EXPECT_EQ(bl.get_num_buffers(), 3u);
> -    EXPECT_EQ(bl.length(), sizeof(long) + 3u);
> +    EXPECT_EQ(bl.length(), sizeof(int64_t) + 3u);
>    }
> -  EXPECT_EQ(bl.length(), 2u * sizeof(long) + 3u);
> +  EXPECT_EQ(bl.length(), 2u * sizeof(int64_t) + 3u);
>  }
>
>  TEST(BufferList, TestPtrAppend) {
>

thanks. i posted your patch as https://github.com/ceph/ceph/pull/29881 .

>
> That was all it took to build ceph-14.2.2-1.fc30 on x86_64 and i686.  I
> haven't even had a chance to check that the resulting packages install,
> and I won't be able to get to them before I'm back home on Thu, but
> these are simple enough that I figured I'd post them before I got my
> attention on something else ;-)
>
> I hope this helps,

it does!

>
> --
> Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
> Be the change, be Free!                 FSF Latin America board member
> GNU Toolchain Engineer                        Free Software Evangelist
> Hay que enGNUrecerse, pero sin perder la terGNUra jam=C3=A1s - Che GNUeva=
ra



--=20
Regards
Kefu Chai
